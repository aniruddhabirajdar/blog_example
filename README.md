# Simple blog application

User can create Post, Comment in this application.
To achieve this without User managment following steps.
- Run `rake db:seed` or `rails db:seed`
- It will create 4 default USERS as fllows:
 1.`{id: 1 , user_name: "TEST 1"}`
 2.`{id: 2 , user_name: "TEST 2"}`
 3.`{id: 3 , user_name: "TEST 3"}`
 4.`{user_name: "GUEST"}`
- While Using API need to add user token in Header 
- User Id is act as token 
- Without token it will take default user GUEST USER

##  Run application
- `rake db:create`
- `rake db:migrate`
- `rake db:seed`
- `rails s`

##  Run application (In application folder)
- `rake db:create`
- `rake db:migrate`
- `rake db:seed`
- `rails s`
 
##  Run Test
- `% rspec`

##  Testing data for report generation 
- `% rake test_data:dump`
 
##  Report generation 
1.Total number of likes and comments a user received for each of his/her post 
##### SQL Qury  to genrate report :
```sh
SELECT user_id,post_id , SUM(comment_count) as comment_count, SUM(like_count) as like_count FROM(
SELECT  posts.user_id,posts.id as post_id, count(comments.id) as comment_count , 0 like_count FROM posts LEFT OUTER  JOIN comments on comments.post_id = posts.id
GROUP BY(posts.id)
UNION
SELECT  posts.user_id,posts.id as post_id  , 0 comment_count , count(likes.id) as  like_count FROM posts LEFT OUTER  JOIN likes on likes.likeable_id = posts.id AND likes.likeable_type = 'Post' GROUP BY(posts.id)
) CountsTable GROUP BY CountsTable.post_id
HAVING user_id = 10
```

In cosole use 
`User.find(10).posts.map(& :report)`
Or 
`User.find(10).like_comment_report`

`User.find(10).like_comment_report` This will fetch date in single DB hit 

2.List of all users(having at least one post) and count of their posts
##### SQL Qury  to genrate report :
```sh
SELECT users.id as user_id,count(users.id) as number_of_posts
From users
LEFT INNER JOIN posts on posts.user_id = users.id  
GROUP BY(users.id)
HAVING count(users.id) > 0
```
In cosole use 
` User.post_count_report_sql`
or 
`User.post_count_report`

## API

#### 1. Create Post
```sh
curl --location --request POST 'http://localhost:3000/api/v1/posts' \
--header 'token: 1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "post": {
        "title": "What is Lorem Ipsum?",
        "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        }
}'
```
Sample Response 
```sh
{
    "id": 6,
    "title": "What is Lorem Ipsum?",
    "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    "user_id": 1,
    "created_at": "2022-05-29T19:29:57.996Z",
    "updated_at": "2022-05-29T19:29:57.996Z"
}
```

#### 2. Read Post
```sh
curl --location --request GET 'http://localhost:3000/api/v1/posts/6' \
--header 'token: 1'
```
Sample Response 
```sh
{
    "id": 6,
    "title": "What is Lorem Ipsum?",
    "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    "user_id": 1,
    "created_at": "2022-05-29T19:29:57.996Z",
    "updated_at": "2022-05-29T19:29:57.996Z",
    "total_likes": 0,
    "comments": []
}
```
#### 3. Create Comment
```sh
curl --location --request POST 'http://localhost:3000/api/v1/posts/6/comments' \
--header 'token: 1' \
--header 'Content-Type: application/json' \
--data-raw '{
    "comment": {
        "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        }
}'
```
Sample Response 
```sh
{
    "id": 8,
    "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    "post_id": 6,
    "user_id": 1,
    "created_at": "2022-05-29T20:02:13.482Z",
    "updated_at": "2022-05-29T20:02:13.482Z",
    "total_likes": 0
}
```
#### 3. Like Post
```sh
curl --location --request POST 'http://localhost:3000/api/v1/posts/6/likes' \
--header 'token: 1'
```
Sample Response 
```sh
{
    "id": 10,
    "likeable_id": 6,
    "likeable_type": "Post",
    "user_id": 1,
    "created_at": "2022-05-29T20:03:38.592Z",
    "updated_at": "2022-05-29T20:03:38.592Z"
}
```

#### 3. Like Comment
```sh
curl --location --request POST 'http://localhost:3000/api/v1/comments/8/likes' \
--header 'token: 1'
```
Sample Response 
```sh
{
    "id": 12,
    "likeable_id": 8,
    "likeable_type": "Comment",
    "user_id": 1,
    "created_at": "2022-05-29T20:06:55.753Z",
    "updated_at": "2022-05-29T20:06:55.753Z"
}
```

#### 3. Read Post
```sh
curl --location --request GET 'http://localhost:3000/api/v1/posts/6' \
--header 'token: 1'
```
Sample Response 
```sh
{
    "id": 6,
    "title": "What is Lorem Ipsum?",
    "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    "user_id": 1,
    "created_at": "2022-05-29T19:29:57.996Z",
    "updated_at": "2022-05-29T19:29:57.996Z",
    "total_likes": 1,
    "comments": [
        {
            "id": 8,
            "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
            "post_id": 6,
            "user_id": 1,
            "created_at": "2022-05-29T20:02:13.482Z",
            "updated_at": "2022-05-29T20:02:13.482Z",
            "total_likes": 1
        }
    ]
}
```

#### 3. Read Comment
```sh
curl --location --request GET 'http://localhost:3000/api/v1/comments/8' \
--header 'token: 1'
```
Sample Response 
```sh
{
    "id": 8,
    "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    "post_id": 6,
    "user_id": 1,
    "created_at": "2022-05-29T20:02:13.482Z",
    "updated_at": "2022-05-29T20:02:13.482Z",
    "total_likes": 1
}
```

#### 3. Read all posts
```sh
curl --location --request GET 'http://localhost:3000/api/v1/posts' \
--header 'token: 1'
```
Sample Response 
```sh
{
    "posts": [
        {
            "id": 1,
            "title": "test",
            "body": "test",
            "user_id": 1,
            "created_at": "2022-05-26T18:51:41.205Z",
            "updated_at": "2022-05-26T18:51:41.205Z",
            "total_likes": 1,
            "comments": [
                {
                    "id": 7,
                    "body": "asdsad",
                    "post_id": 1,
                    "user_id": 2,
                    "created_at": "2022-05-29T17:35:40.927Z",
                    "updated_at": "2022-05-29T17:35:40.927Z",
                    "total_likes": 1
                }
            ]
        },
        {
            "id": 2,
            "title": "test",
            "body": "test",
            "user_id": 1,
            "created_at": "2022-05-26T18:52:39.310Z",
            "updated_at": "2022-05-26T18:52:39.310Z",
            "total_likes": 1,
            "comments": [
                {
                    "id": 1,
                    "body": "test",
                    "post_id": 2,
                    "user_id": 1,
                    "created_at": "2022-05-26T18:59:03.202Z",
                    "updated_at": "2022-05-26T18:59:03.202Z",
                    "total_likes": 2
                },
                {
                    "id": 2,
                    "body": "asdsad",
                    "post_id": 2,
                    "user_id": 2,
                    "created_at": "2022-05-29T17:28:57.658Z",
                    "updated_at": "2022-05-29T17:28:57.658Z",
                    "total_likes": 0
                },
                {
                    "id": 3,
                    "body": "asdsad",
                    "post_id": 2,
                    "user_id": 2,
                    "created_at": "2022-05-29T17:32:08.192Z",
                    "updated_at": "2022-05-29T17:32:08.192Z",
                    "total_likes": 0
                },
                {
                    "id": 4,
                    "body": "asdsad",
                    "post_id": 2,
                    "user_id": 2,
                    "created_at": "2022-05-29T17:32:43.392Z",
                    "updated_at": "2022-05-29T17:32:43.392Z",
                    "total_likes": 0
                },
                {
                    "id": 5,
                    "body": "asdsad",
                    "post_id": 2,
                    "user_id": 2,
                    "created_at": "2022-05-29T17:32:46.231Z",
                    "updated_at": "2022-05-29T17:32:46.231Z",
                    "total_likes": 0
                },
                {
                    "id": 6,
                    "body": "asdsad",
                    "post_id": 2,
                    "user_id": 2,
                    "created_at": "2022-05-29T17:32:47.010Z",
                    "updated_at": "2022-05-29T17:32:47.010Z",
                    "total_likes": 2
                }
            ]
        },
        {
            "id": 3,
            "title": "test",
            "body": "test",
            "user_id": 1,
            "created_at": "2022-05-26T18:55:35.971Z",
            "updated_at": "2022-05-26T18:55:35.971Z",
            "total_likes": 0,
            "comments": []
        },
        {
            "id": 4,
            "title": "What is Lorem Ipsum?",
            "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
            "user_id": 1,
            "created_at": "2022-05-29T19:21:01.963Z",
            "updated_at": "2022-05-29T19:21:01.963Z",
            "total_likes": 0,
            "comments": []
        },
        {
            "id": 5,
            "title": "What is Lorem Ipsum?",
            "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
            "user_id": 1,
            "created_at": "2022-05-29T19:26:07.590Z",
            "updated_at": "2022-05-29T19:26:07.590Z",
            "total_likes": 0,
            "comments": []
        },
        {
            "id": 6,
            "title": "What is Lorem Ipsum?",
            "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
            "user_id": 1,
            "created_at": "2022-05-29T19:29:57.996Z",
            "updated_at": "2022-05-29T19:29:57.996Z",
            "total_likes": 1,
            "comments": [
                {
                    "id": 8,
                    "body": "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                    "post_id": 6,
                    "user_id": 1,
                    "created_at": "2022-05-29T20:02:13.482Z",
                    "updated_at": "2022-05-29T20:02:13.482Z",
                    "total_likes": 1
                }
            ]
        }
    ],
    "totla_posts": 6
}
```


