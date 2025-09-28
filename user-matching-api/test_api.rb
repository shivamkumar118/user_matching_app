#!/usr/bin/env ruby

require 'net/http'
require 'json'
require 'uri'

# API base URL
BASE_URL = 'http://localhost:3000/api/v1'

def make_request(method, endpoint, body = nil, token = nil)
  uri = URI("#{BASE_URL}#{endpoint}")
  
  case method.upcase
  when 'GET'
    request = Net::HTTP::Get.new(uri)
  when 'POST'
    request = Net::HTTP::Post.new(uri)
  when 'PUT'
    request = Net::HTTP::Put.new(uri)
  when 'DELETE'
    request = Net::HTTP::Delete.new(uri)
  end
  
  request['Content-Type'] = 'application/json'
  request['Authorization'] = "Bearer #{token}" if token
  request.body = body.to_json if body
  
  response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(request)
  end
  
  {
    status: response.code,
    body: JSON.parse(response.body)
  }
rescue => e
  {
    status: 'ERROR',
    body: { error: e.message }
  }
end

def print_response(title, response)
  puts "\n" + "="*50
  puts title
  puts "="*50
  puts "Status: #{response[:status]}"
  puts "Response: #{JSON.pretty_generate(response[:body])}"
end

puts "Testing User Matching API..."
puts "Make sure the Rails server is running on http://localhost:3000"

# Test 1: Login
puts "\n1. Testing Login..."
login_response = make_request('POST', '/auth/login', {
  email: 'john.doe@example.com',
  password: 'password123'
})

print_response('Login Response', login_response)

if login_response[:status] == '200'
  token = login_response[:body]['data']['token']
  puts "\n✅ Login successful! Token: #{token[0..20]}..."
  
  # Test 2: Get Questions
  puts "\n2. Testing Get Questions..."
  questions_response = make_request('GET', '/questions', nil, token)
  print_response('Questions Response', questions_response)
  
  # Test 3: Get Users
  puts "\n3. Testing Get Users..."
  users_response = make_request('GET', '/users', nil, token)
  print_response('Users Response', users_response)
  
  # Test 4: Get Matching Users
  puts "\n4. Testing Get Matching Users..."
  matching_response = make_request('GET', '/matching/users', nil, token)
  print_response('Matching Users Response', matching_response)
  
  # Test 5: Get User Profile
  puts "\n5. Testing Get User Profile..."
  profile_response = make_request('GET', '/users/1/profile', nil, token)
  print_response('User Profile Response', profile_response)
  
else
  puts "\n❌ Login failed! Please check if the server is running and seed data is loaded."
end

puts "\n" + "="*50
puts "API Testing Complete!"
puts "="*50
puts "\nTo test more endpoints, use the API_DOCUMENTATION.md file"
puts "or use tools like Postman, Insomnia, or curl." 