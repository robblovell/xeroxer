module Xeroxer
  class ProtocolNotSupported < Exception; end
  class BlockReadNotSupported < Exception; end
  class MalformedUrl < Exception; end
  class NoS3CredentialsGiven < Exception; end
  class InvalidAclException < Exception; end
end