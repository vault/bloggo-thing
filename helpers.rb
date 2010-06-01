
helpers do
  def authentic? sig pub_key
    sig.certificates[0].verify(pub_key)
  end

  def verify_authenticity!
    halt 400 unless params[:sig] && params[:data]
    sig = OpenSSL::PKCS7.new params[:sig]
    email = sig.signers[0].name.match(/emailAddress=(.*)\/?/)[0]
    @user = DB.get email
    halt 403 unless user[:pub_keys].any? {|key| authentic? sig, key }
  end

  def sanitize_title title
    title.downcase.gsub(/[^a-z0-9]/, '-').squeeze('-').gsub(/^\-|\-$/, '')
  end

end
