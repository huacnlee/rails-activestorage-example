# Rails use Active Storage the right way

Rails [Active Storage](https://guides.rubyonrails.org/active_storage_overview.html) was coming from Rails 5.0, but how can we use it.

[中文说明文档](https://ruby-china.org/topics/37717)

The Rails official guides not give we so much details for how can we use it in a real world project.

Some issues:

1. By default, Active Storage generate URL is for private ACL case.
2. In image thumb (avatar, cover) cases, it output a long URL, and including sign (by `secret_key_base`), if we want insert the image URL into a rich text, that unstabe.

----

So, how can we do?

This project will show you the right way to use Active Storage (`:disk` service) for the `public ACL`.

## Point change

Add a `app/controllers/uploads_controller.rb` for instead of Active Storage controller:

```rb
class UploadsController < ApplicationController
  before_action :require_disk_service!
  before_action :set_blob

  # GET /upload/:id
  # GET /upload/:id?s=large
  def show
    if params[:s]
      # generate thumb
      variation_key = Blob.variation(params[:s])
      send_file_by_disk_key @blob.representation(variation_key).processed.key, content_type: @blob.content_type
    else
      # return raw file
      send_file_by_disk_key @blob.key, content_type: @blob.content_type, disposition: params[:disposition], filename: @blob.filename
    end
  end

  private

    def send_file_by_disk_key(key, content_type:, disposition: :inline, filename: nil)
      opts = { type: content_type, disposition: disposition, filename: filename }
      send_file Blob.path_for(key), opts
    end

    def set_blob
      @blob = ActiveStorage::Blob.find_by(key: params[:id])
      head :not_found if @blob.blank?
    end

    def require_disk_service!
      head :not_found unless Blob.disk_service?
    end
end
```

Do not miss add route:

```rb
resources :uploads
```

We need a `app/model/blob.rb` to configuation the image resize rules, and provider some method for generate image thumb:

```rb
class Blob
  class << self
    IMAGE_SIZES = { tiny: 32, small: 64, medium: 96, xlarge: 2400 }

    def disk_service?
      ActiveStorage::Blob.service.send(:service_name) == "Disk"
    end

    def variation(style)
      ActiveStorage::Variation.new(combine_options: combine_options(style))
    end

    def combine_options(style)
      style = style.to_sym
      size = IMAGE_SIZES[style] || IMAGE_SIZES[:small]

      if style == :xlarge
        { resize: "#{size}>" }
      else
        { thumbnail: "#{size}x#{size}^", gravity: "center", extent: "#{size}x#{size}" }
      end
    end

    def path_for(key)
      ActiveStorage::Blob.service.send(:path_for, key)
    end
  end
end
```

Finally, use the `upload_path` to genrate image URL with the Public URL scenes:

```rb
<%= image_tag upload_path(@user.avatar.blob.key, s: :small) %>
```

You better add a `avatar_url` method into **User** model, so use can easily genrate avatar URL for API or serializer.

```rb
class User < ApplicationRecord
  def avatar_url(style: :small)
    return "" unless self.avatar.attached?

    Rails.application.routes.url_helpers.upload_path(self.avatar.blob.key, s: style)
  end
end
````

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


## Getting started

Run migrate

```bash
$ git clone git@github.com:huacnlee/rails-activestorage-example.git
$ cd rails-activestorage-example
$ rails db:create db:migrate
$ rails s
```

And the visit http://localhost:3000

<img width="239" alt="2018-11-01 5 00 52" src="https://user-images.githubusercontent.com/5518/47842749-94a0e380-ddf8-11e8-957d-80cf83da7b2e.png">

<img width="409" alt="2018-11-01 5 00 57" src="https://user-images.githubusercontent.com/5518/47842765-9cf91e80-ddf8-11e8-8ebd-31df0519f1d8.png">

<img width="285" alt="2018-11-01 5 00 39" src="https://user-images.githubusercontent.com/5518/47842773-a2eeff80-ddf8-11e8-8db0-a6540d3cede3.png">

<img width="389" alt="2018-11-01 5 00 33" src="https://user-images.githubusercontent.com/5518/47842784-a8e4e080-ddf8-11e8-9220-b3722c5b9fc4.png">
