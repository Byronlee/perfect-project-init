settings.url_code_begin = 33_000

settings.redis_servers = {
  cache: 'redis://127.0.0.1:6379/1',
  session: 'redis://127.0.0.1:6379/2'
}

settings.oauth = {
  krypton: {
    #host: 'https://auth.36kr.com',
    host: 'https://passport.36kr.com',
    app_id: '9767d4838b9664ca33a1630f6a7889d8b78a1dfd0bcf4b257a3c95122bf9ceaa',
    secret: 'e0df3c21ee500eaf85687357290f6c61878559f22eb0ce24c4ba3219c2666c07',
    redirect_uri_full_host: 'http://client.36kr.com',
    cookie: {
      name: 'krid_user_version',
      domain: '.36kr.com'
    }
  }
}

# 读者, 运营, 作者, 编辑, 管理员, 投稿, 专栏作者
settings.roles =  [:reader, :operator, :writer, :editor, :admin, :contributor, :column_writer]
settings.user_search_support = [['角色', 'role'], ['ID', 'id'], ['姓名', 'name'], ['电话', 'phone'], ['邮件', 'email'], ['sso_id', 'sso_id']]
settings.editable_roles =  [:operator, :writer, :editor, :admin]

settings.post_views_count_cache = 100

settings.ga = {
  tracker: 'UA-1268479-12'
}

settings.page_views = { persist: true }

settings.site_map = { posts_count: 2000 }

settings.comment_time_interval = 30.seconds

settings.cache={
  default_expires_in: 1.hour
}
