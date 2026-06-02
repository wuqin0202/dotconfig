# ============================ Proxy Functions ============================

function proxy -d "Set proxy environment variables"
    set hostip localhost
    set socks_hostport 7890
    set http_hostport 7890

    # Parse options: -h hostip, -s socks_port, -p http_port
    argparse 'h/hostip=' 's/socks=' 'p/http=' -- $argv

    if set -q _flag_hostip
        set hostip $_flag_hostip
    end
    if set -q _flag_socks
        set socks_hostport $_flag_socks
    end
    if set -q _flag_http
        set http_hostport $_flag_http
    end

    set -gx https_proxy "http://$hostip:$http_hostport"
    set -gx http_proxy "http://$hostip:$http_hostport"
    set -gx ALL_PROXY "socks5://$hostip:$socks_hostport"
    set -gx all_proxy "socks5://$hostip:$socks_hostport"
end

function unproxy -d "Unset proxy environment variables"
    set -e ALL_PROXY
    set -e https_proxy
    set -e http_proxy
    set -e all_proxy
end

function testproxy -d "Test if proxy is working"
    curl -v google.com
end

function listproxy -d "List current proxy settings"
    echo $ALL_PROXY
    echo $all_proxy
    echo $https_proxy
    echo $http_proxy
end
