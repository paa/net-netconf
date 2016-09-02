module Netconf
  module RPC

    MSG_END = ']]>]]>'
    MSG_END_RE = /\]\]>\]\]>[\r\n]*$/
    MSG_END_1_1 = "\n##\n"
    MSG_CHUNK_SIZE_RE = /\n#\d+\n*$/
    MSG_CLOSE_SESSION = '<rpc><close-session/></rpc>'
    MSG_HELLO = <<-EOM
<hello xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <capabilities>
    <capability>urn:ietf:params:netconf:base:1.0</capability>
    <capability>urn:ietf:params:netconf:base:1.1</capability>
  </capabilities>
</hello>
EOM

  module Standard
    def lock( target )
      run_valid_or_lock_rpc "<rpc><lock><target><#{target}/></target></lock></rpc>",
                            Netconf::LockError
    end

    def unlock( target )
      rpc = Nokogiri::XML( "<rpc><unlock><target><#{target}/></target></unlock></rpc>" ).root
      @trans.rpc_exec( rpc )
    end

    def validate( source )
      run_valid_or_lock_rpc "<rpc><validate><source><#{source}/></source></validate></rpc>",
                            Netconf::ValidateError
    end

    def run_valid_or_lock_rpc(rpc_string, error_type)
      rpc = Nokogiri::XML(rpc_string).root
      Netconf::RPC.set_exception( rpc, error_type )
      @trans.rpc_exec( rpc )
    end

    def commit
      rpc = Nokogiri::XML( "<rpc><commit/></rpc>" ).root
      Netconf::RPC.set_exception( rpc, Netconf::CommitError )
      @trans.rpc_exec( rpc )
    end

    def delete_config( target )
      rpc = Nokogiri::XML( "<rpc><delete-config><target><#{target}/></target></delete-config></rpc>" ).root
      @trans.rpc_exec( rpc )
    end

    def close_session
      rpc = Nokogiri::XML( MSG_CLOSE_SESSION ).root
      @trans.rpc_exec( rpc )
    end

    def munge_xml(data)
      case data.class.to_s
      when /^Nokogiri/
        case data
        when Nokogiri::XML::Builder  then data.doc.root
        when Nokogiri::XML::Document then data.root
        else data
        end
      when 'String' then Nokogiri::XML(data).root
      end
    end

    def get_config(source: 'running', filter: nil)
      rpc = Nokogiri::XML("<rpc><get-config><source><#{source}/></source></get-config></rpc>").root

      if block_given?
        Nokogiri::XML::Builder.with( rpc.at( 'get-config' )){ |xml|
          xml.filter( :type => 'subtree' ) {
            yield( xml )
          }
        }
      end

      if filter
        f_xml = munge_xml(filter)
        if f_xml
          f_node = Nokogiri::XML::Node.new( 'filter', rpc )
          f_node['type'] = 'subtree'
          f_node << f_xml
          rpc.at('get-config') <<  f_node
        else
          raise ArgumentError, "filter must be valid XML string or object!"
        end
      end

      @trans.rpc_exec( rpc )
    end

    def edit_config(toplevel: 'config', target: 'candidate', config: nil)
      rpc_str = <<-EO_RPC
<rpc>
<edit-config>
   <target><#{target}/></target>
   <#{toplevel}/>
</edit-config>
</rpc>
EO_RPC

      rpc = Nokogiri::XML( rpc_str ).root

      if block_given?
        Nokogiri::XML::Builder.with(rpc.at( toplevel )){ |xml|
          yield( xml )
        }
      elsif config
        conf_xml = munge_xml(config)
        if conf_xml
          rpc.at( toplevel ) << conf_xml
        else
          raise ArgumentError, "config must be valid XML string or object!"
        end
      else
        raise ArgumentError, "You must specify edit-config data!"
      end

      Netconf::RPC.set_exception( rpc, Netconf::EditError )
      @trans.rpc_exec( rpc )
    end

  end

  end # module: RPC
end # module: Netconf
