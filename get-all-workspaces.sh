curl -X GET "https://api.trello.com/1/members/me/organizations?key=$TRELLO_API_KEY&token=$TRELLO_RUBY_TOKEN" | python3 -m json.tool
