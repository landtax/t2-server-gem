# Copyright (c) 2010-2012 The University of Manchester, UK.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
#  * Neither the names of The University of Manchester nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# Author: Robert Haines

module T2Server

  # This class serves as a base class for concrete HTTP credential systems.
  #
  # Instances of this class cannot be used to authenticate a connection;
  # please use HttpBasic instead.
  class HttpCredentials
    # The username held by these credentials.
    attr_reader :username

    # :stopdoc:
    # Create a set of credentials with the supplied username and password.
    def initialize(username, password)
      @username = username
      @password = password
    end
    # :startdoc:

    # :call-seq:
    #   to_s -> String
    #
    # Return a String representation of these credentials. Just the username
    # is returned; the password is kept hidden.
    def to_s
      @username
    end

    # Used within #inspect, below to help override the built in version.
    @@to_s = Kernel.instance_method(:to_s)

    # :call-seq:
    #   inspect -> String
    #
    # Override the Kernel#inspect method so that the password is not exposed
    # when it is called.
    def inspect
      @@to_s.bind(self).call.sub!(/>\z/) {" Username:#{self}>"}
    end
  end

  # A class representing HTTP Basic credentials. Use this class to
  # authenticate operations on a Taverna Server that require it.
  #
  # See also Util.strip_uri_credentials.
  class HttpBasic < HttpCredentials

    # :call-seq:
    #   new(username, password) -> HttpBasic
    #
    # Create a set of basic credentials using the supplied username and
    # password.
    def initialize(username, password)
      super(username, password)
    end

    # :stopdoc:
    # Authenticate the supplied HTTP request with the credentials held within
    # this class.
    def authenticate(request)
      request.basic_auth @username, @password
    end
    # :startdoc:
  end
end
