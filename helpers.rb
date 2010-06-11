
helpers do
  # make sure the person is who they say they are
  def decrypt_data!
    encr_data = params['data']
    request_hash = params['hash']
    keys = @user['pub_keys'].dup
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
    title.downcase.gsub.(/'|"/,'').gsub(/[^a-z0-9]/, '-').squeeze('-').gsub(/^\-|\-$/, '')
  end

  def get_user name
    if USERS[name]
      return USERS[name]
    else
      halt 400
    end
  end

  def get_article name
    if POSTS[name]
      return POSTS[name]
    else
      halt 404
    end
  end

  def save_post data
    clean_title = sanitize_title data['title']
    f = File.new("data/#{@user['email']}/#{clean_title}.json", 'w')
    unless POSTS[clean_title]
      data['date_posted'] = Time.now
      data['clean_title'] = clean_title
      data['author'] = @user['email']
      f.write data.to_json
      POSTS[clean_title] = data
    else
      data['date_updated'] = Time.now
      f.write data.to_json
    end
  end
end

def read_all_users!
  Dir.chdir("data") do
    Dir.glob("*@*") do |dir|
      Dir.chdir(dir) do
        user = JSON.parse(File.read 'userinfo.json')
        keys = JSON.parse(File.read 'keys.json')
        user['pub_keys'] = keys
        USERS[user['email']] = user
      end
    end
  end
end

def read_all_posts!
  Dir.chdir("data") do 
    Dir.glob("*@*") do |dir|
      Dir.chdir("#{dir}/posts") do
        Dir.glob("*.json") do |file|
          data = JSON.parse(File.read file)
          POSTS[data['clean_title']] = data
        end
      end
    end
  end
end

