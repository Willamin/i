require "digest/md5"
print Digest::MD5.hexdigest(ARGV.join(" "))
