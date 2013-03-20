module Xeroxer
  class ProtocolNotSupported < Exception; end
  class BlockReadNotSupported < Exception; end
  class MalformedUrl < Exception; end
  class NoS3CredentialsGiven < Exception; end
end