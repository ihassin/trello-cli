curl --request GET \
  --url "https://api.trello.com/1/members/$TRELLO_MEMBERS?key=$TRELLO_API_KEY&token=$TRELLO_RUBY_TOKEN" \
  --header 'Accept: application/json'  | python3 -m json.tool
