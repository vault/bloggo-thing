
helpers do
  def decrypt_data!
    encr_data = params['data']
    request_hash = params['hash']
    keys = @user['pub_keys']
    key = OpenSSL::PKey::RSA.new(keys.shift)
    begin
      hashstring = key.public_decrypt(request_hash)
      iv = hashstring[0,16]
      hash = hashstring[16,hashstring.size]
      data = decrypt hash, iv, encr_data
    rescue OpenSSL::PKey::RSAError
      n = keys.shift
      unless n.nil?
        key = OpenSSL::PKey::RSA.new(n)
        retry
      end
      halt 403
    end
    data_hash = Digest::SHA256.hexdigest(data)
    halt 400 unless data_hash == hash
    data
  end

  def decrypt key, iv, data
    cipher = OpenSSL::Cipher.new('AES256').decrypt
    cipher.key = key
    cipher.iv = iv
    decrypted = cipher.update(data) << cipher.final
  end

  def sanitize_title title
    title.downcase.gsub(/'|"/,'').gsub(/[^a-z0-9]/, '-').squeeze('-').gsub(/^\-|\-$/, '')
  end

  def get_user name
    begin
      settings.db.get name
    rescue RestClient::ResourceNotFound
      halt 400
    end
  end

  def get_article name
    begin
      return settings.db.get name
    rescue RestClient::ResourceNotFound
      halt 404
    end
  end

  def usershash
    h = {}
    settings.db.view('users/all')['rows'].each do |row|
      h[row['id']] = row['value']
    end
    h
  end

  def posts_array posts
    posts.collect! { |lm| lm['value'] }
    posts.each {|p| parse_times! p }
    return posts
  end

  def save_post data
    clean_title = sanitize_title data['title']
    data['_id'] = clean_title
    begin
      old = settings.db.get clean_title
      data['date_updated'] = Time.now
      old.merge! data
      settings.db.save_doc old
      :updated
    rescue RestClient::ResourceNotFound
      data['date_posted'] = Time.now
      settings.db.save_doc data
      :new
    end
  end

  def doc_count
    settings.db.view('posts/count')['rows'][0]['value']
  end

  def parse_times! post
    post['date_posted'] = Time.parse post['date_posted']
    post['date_updated'] = Time.parse post['date_updated'] if post['date_updated']
  end

  def firstpage?
    if @page
      @page == 1
    else
      false
    end
  end

  def lastpage?
    if @page
      skip = @page.pred * settings.per_page
      skip + settings.per_page >= doc_count
    else
      false
    end
  end
end

class Time
  def machine; strftime("%Y-%m-%d"); end
  def readable; strftime("%B %d, %Y"); end
end
