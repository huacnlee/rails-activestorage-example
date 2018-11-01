# Rails use Active Storage the right way

Rails [Active Storage](https://guides.rubyonrails.org/active_storage_overview.html) was coming from Rails 5.0, but how can we use it.

The Rails official guides not give we so much details for how can we use it in a real world project.

Some issues:

1. By default, Active Storage generate URL is for private ACL case.
2. In image thumb (avatar, cover) cases, it output a long URL, and including sign (by `secret_key_base`), if we want insert the image URL into a rich text, that unstabe.

----

So, how can we do?

This project will show you the right way to use Active Storage (`:disk` service) for the `public ACL`.

<img width="239" alt="2018-11-01 5 00 52" src="https://user-images.githubusercontent.com/5518/47842749-94a0e380-ddf8-11e8-957d-80cf83da7b2e.png">

<img width="409" alt="2018-11-01 5 00 57" src="https://user-images.githubusercontent.com/5518/47842765-9cf91e80-ddf8-11e8-8ebd-31df0519f1d8.png">

<img width="285" alt="2018-11-01 5 00 39" src="https://user-images.githubusercontent.com/5518/47842773-a2eeff80-ddf8-11e8-8db0-a6540d3cede3.png">

<img width="389" alt="2018-11-01 5 00 33" src="https://user-images.githubusercontent.com/5518/47842784-a8e4e080-ddf8-11e8-9220-b3722c5b9fc4.png">


## Getting started

```bash
$ rails new my-project
$ cd my-project
$ bundle install
```

And the generate Active Storage files:

```bash
$ rails active_storage:install
```

And we needs a User model for avatar case:

```bash
$ rails g scaffold User name:string
```

A Post model for `rich text` case:

```
$ rails g scaffold Post title:string body:text
```

Run migrate

```bash
$ rails db:create db:migrate
```

## More detail please see the files:

- app/model/blob.rb
- app/model/user.rb
- app/model/post.rb
- config/routes.rb
- app/controller/uploads_controller.rb
- app/views/posts/_form.html.erb
- app/views/posts/show.html.erb
- app/views/users/_form.html.erb
- app/views/users/show.html.erb
