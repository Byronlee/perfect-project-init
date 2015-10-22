class Krypton::Passport
  def initialize(access_token_hash)
    @access_token_hash = access_token_hash
  end

  def me
    Hashie::Mash.new access_token.get("/api/v1/users/me").parsed
  end

  def access_token
    @access_token ||= OAuth2::AccessToken.new self.class.client, @access_token_hash
  end

  class << self
    include Rails.application.routes.url_helpers

    def invite(email, options = {})
      access_token.post("/api/v1/users/invite", params: {
        email: email,
        redirect_uri: Settings.site,
        notification: {
          subject: Settings.users.invitation.subject,
          body: Settings.users.invitation.body,
        }
      }.merge(options)).parsed
      true
    rescue OAuth2::Error => e
      case e.response.status
      when 422
        # email 有误(格式不正确 / 用户已经存在)
      end
      return false
    end

    def get_origin_ids(uid)
      Hashie::Mash.new access_token.get("/api/v1/users/#{uid}/origin_ids").parsed
    rescue OAuth2::Error => e
      case e.response.status
      when 404
      end
      return {}
    end

    def find(key)
      Hashie::Mash.new access_token.get("/api/v1/users/show", params: { id: key }).parsed
    rescue OAuth2::Error => e
      case e.response.status
      when 404
        return nil
      else
        raise e
      end
    end

    def update(id, params = {})
      Hashie::Mash.new access_token.put("/api/v1/users/#{id}", params: params).parsed
    rescue OAuth2::Error => e
      case e.response.status
      when 404
        return nil
      when 422
        return nil # 修改字段格式校验失败
      else
        raise e
      end
    end

    def client
      @client ||= OAuth2::Client.new(Settings.oauth.krypton.app_id, Settings.oauth.krypton.secret,
        site: Settings.oauth.krypton.host)
    end

  private
    def access_token
      @access_token ||= begin
        if json = $redis.get(:krypton_passport_access_token)
          access_token = OAuth2::AccessToken.from_hash client, JSON.parse(json)
        else
          access_token = client.client_credentials.get_token
          $redis.set(:krypton_passport_access_token, access_token.to_json,
            ex: access_token.expires_in.seconds - 1.minute)
          access_token
        end
      end
    end
  end
end
