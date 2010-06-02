
helpers do
  # make sure the person is who they say they are
  def decrypt_data!
    encr_data = params[:data]
    request_hash = params[:hash]
    keys = @user[:pub_keys]
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

  def in_hash_form users
    us = {}
    users.each do |u|
      us[u["value"]["id"]] = u["value"]
    end
    us
  end

  def in_array_form posts
    ps = []
    posts.each do |post|
      ps << post["value"]
    end
    ps
  end

  def decrypt key, iv, data
    cipher = OpenSSL::Cipher.new('AES256').decrypt
    cipher.key = key
    cipher.iv = iv
    decrypted = cipher.update(data) << cipher.final
  end

  def sanitize_title title
    title.downcase.gsub(/[^a-z0-9]/, '-').squeeze('-').gsub(/^\-|\-$/, '')
  end

  def post_doc data
    halt 400 unless data["title"] && data["body"]
    id = sanitize_title data["title"]
    begin
      doc = $DB.get id
      $DB.save_doc({"_id" => id,
                   "_rev" => doc["_rev"],
                 "author" => @user["_id"],
                  "title" => data["title"],
                   "body" => data["body"],
            "date_posted" => doc["date_posted"],
           "date_updated" => Time.now})
      status = "change"
    rescue RestClient::ResourceNotFound
      $DB.save_doc({"_id" => id,
                 "author" => @user["_id"],
                  "title" => data["title"],
                   "body" => data["body"],
            "date_posted" => Time.now})
      status = "new"
    end
  end
end

