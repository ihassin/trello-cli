for board_id in "5d3e710177a2d08451c3113c" "5d8c299b08f205673c997b2d" "5eac6d681fc546241ecaab13" "5ecd4f8cb536cf4296966266" "602b073d6a7e3828852632e0" "61efe8c25221690da4e28d35" "61eea4c27aa5cf803cf96086" "62a8b3028b8db32f021014f4" "5e83a09b9c3901580eb0ce9f" "5e84b1617568175d35744d78" "5e84e48a5ceabf338964651b" "639265e321ff4d00f3b701ae" "620f076d97e31174becfb130" "627bc6ab5445ee61e61a228d" "6671db837915e3732b6c7ff7"
do
  curl --request GET \
    --url "https://api.trello.com/1/boards/$board_id?key=$TRELLO_API_KEY&token=$TRELLO_RUBY_TOKEN" \
    --header 'Accept: application/json' | python3 -m json.tool
done
