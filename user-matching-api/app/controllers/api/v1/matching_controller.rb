class Api::V1::MatchingController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :authenticate_user!

  def users
    other_users = User.where.not(id: current_user.id)
    
    # Apply search filter if provided
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      other_users = other_users.joins(:skills, :experiences)
                              .where(
                                "LOWER(users.first_name) LIKE ? OR LOWER(users.last_name) LIKE ? OR LOWER(users.email) LIKE ? OR LOWER(users.address) LIKE ? OR LOWER(users.bio) LIKE ? OR LOWER(users.about) LIKE ? OR LOWER(skills.value) LIKE ? OR LOWER(experiences.job_title) LIKE ? OR LOWER(experiences.company_name) LIKE ?",
                                search_term, search_term, search_term, search_term, search_term, search_term, search_term, search_term, search_term
                              ).distinct
    end
    
    # Apply match score filter if provided
    min_score = case params[:filter]
                when 'highMatch'
                  0.8
                when 'mediumMatch'
                  0.6
                when 'lowMatch'
                  0.0
                else
                  0.0
                end
    
    users_with_scores = other_users.map do |user|
      match_score = calculate_match_score(current_user, user)
      {
        user: UserSerializer.new(user).as_json,
        match_score: match_score,
        match_percentage: (match_score * 100).round(2)
      }
    end

    # Filter by minimum score if specified
    if min_score > 0.0
      users_with_scores = users_with_scores.select { |user_data| user_data[:match_score] >= min_score }
    end

    # Sort by match score (highest first)
    users_with_scores.sort_by! { |user_data| -user_data[:match_score] }

    render_success({
      users: users_with_scores
    }, 'Users with match scores retrieved successfully')
  end

  def calculate_match
    user = User.find(params[:user_id])
    match_score = calculate_match_score(current_user, user)
    breakdown = calculate_match_breakdown(current_user, user)

    render_success({
      user: UserSerializer.new(user).as_json,
      match_score: match_score,
      match_percentage: (match_score * 100).round(2),
      breakdown: breakdown
    }, 'Match score calculated successfully')
  rescue ActiveRecord::RecordNotFound
    render_error('User not found', nil, :not_found)
  end

  def compatibility
    user1 = User.find(params[:user_id])
    user2 = User.find(params[:other_user_id])
    match_score = calculate_match_score(user1, user2)

    render_success({
      user1: UserSerializer.new(user1).as_json,
      user2: UserSerializer.new(user2).as_json,
      match_score: match_score,
      match_percentage: (match_score * 100).round(2)
    }, 'Compatibility calculated successfully')
  rescue ActiveRecord::RecordNotFound
    render_error('User not found', nil, :not_found)
  end

  private

  def calculate_match_score(user1, user2)
    answer_similarity = calculate_answer_similarity(user1, user2)
    skill_similarity = calculate_skill_similarity(user1, user2)
    experience_similarity = calculate_experience_similarity(user1, user2)
    profile_completion_similarity = calculate_profile_completion_similarity(user1, user2)

    # Weighted average
    (answer_similarity * 0.4 + skill_similarity * 0.3 + 
     experience_similarity * 0.2 + profile_completion_similarity * 0.1).round(4)
  end

  def calculate_match_breakdown(user1, user2)
    {
      answer_similarity: calculate_answer_similarity(user1, user2),
      skill_similarity: calculate_skill_similarity(user1, user2),
      experience_similarity: calculate_experience_similarity(user1, user2),
      profile_completion_similarity: calculate_profile_completion_similarity(user1, user2)
    }
  end

  def calculate_answer_similarity(user1, user2)
    return 0.0 if user1.answers.empty? || user2.answers.empty?

    common_questions = user1.answers.joins(:question).pluck(:question_id) & 
                      user2.answers.joins(:question).pluck(:question_id)
    
    return 0.0 if common_questions.empty?

    similarities = common_questions.map do |question_id|
      answer1 = user1.answers.find_by(question_id: question_id)
      answer2 = user2.answers.find_by(question_id: question_id)
      
      # Simple text similarity (you could use more sophisticated algorithms)
      text1 = answer1.answer_text.downcase
      text2 = answer2.answer_text.downcase
      
      # Calculate similarity based on common words
      words1 = text1.split(/\W+/)
      words2 = text2.split(/\W+/)
      common_words = words1 & words2
      total_words = (words1 + words2).uniq
      
      common_words.length.to_f / total_words.length
    end

    similarities.sum / similarities.length
  end

  def calculate_skill_similarity(user1, user2)
    return 0.0 if user1.skills.empty? || user2.skills.empty?

    skills1 = user1.skills.pluck(:value, :category)
    skills2 = user2.skills.pluck(:value, :category)
    
    common_skills = skills1 & skills2
    total_skills = (skills1 + skills2).uniq
    
    common_skills.length.to_f / total_skills.length
  end

  def calculate_experience_similarity(user1, user2)
    return 0.0 if user1.experiences.empty? || user2.experiences.empty?

    # Compare job titles and companies
    titles1 = user1.experiences.pluck(:job_title)
    titles2 = user2.experiences.pluck(:job_title)
    
    companies1 = user1.experiences.pluck(:company_name)
    companies2 = user2.experiences.pluck(:company_name)
    
    common_titles = titles1 & titles2
    common_companies = companies1 & companies2
    
    total_titles = (titles1 + titles2).uniq
    total_companies = (companies1 + companies2).uniq
    
    title_similarity = total_titles.empty? ? 0.0 : common_titles.length.to_f / total_titles.length
    company_similarity = total_companies.empty? ? 0.0 : common_companies.length.to_f / total_companies.length
    
    (title_similarity + company_similarity) / 2.0
  end

  def calculate_profile_completion_similarity(user1, user2)
    completion1 = user1.profile_completion_percentage / 100.0
    completion2 = user2.profile_completion_percentage / 100.0
    
    # Similarity based on how close their completion percentages are
    1.0 - (completion1 - completion2).abs
  end
end
