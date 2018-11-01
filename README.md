# Rails use Active Storage the right way

Rails [Active Storage](https://guides.rubyonrails.org/active_storage_overview.html) was coming from Rails 5.0, but how can we use it.

The Rails official guides not give we so much details for how can we use it in a real world project.

Some issues:

1. By default, Active Storage generate URL is for private ACL case.
2. In image thumb (avatar, cover) cases, it output a long URL, and including sign (by `secret_key_base`), if we want insert the image URL into a rich text, that unstabe.

----

So, how can we do?

This project will show you the right way to use Active Storage (`:disk` service) for the `public ACL`.

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
