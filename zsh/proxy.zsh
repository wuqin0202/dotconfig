proxy() {
    # 设置代理，参数 -h 指定hostip，-s 指定socks_hostport，-p 指定http_hostport
    # hostip=$(ip route | grep default | awk '{print $3}')
    hostip="localhost"
    socks_hostport=7890
    http_hostport=7890
    while getopts "h:s:p:" opt; do
        case $opt in
            h) hostip=$OPTARG ;;
            s) socks_hostport=$OPTARG ;;
            p) http_hostport=$OPTARG ;;
        esac
    done
    export https_proxy="http://${hostip}:${http_hostport}"
    export http_proxy="http://${hostip}:${http_hostport}"
    export ALL_PROXY="socks5://${hostip}:${socks_hostport}"
    export all_proxy="socks5://${hostip}:${socks_hostport}"

    unset hostip socks_hostport http_hostport
}

unproxy() {
    unset ALL_PROXY
    unset https_proxy
    unset http_proxy
    unset all_proxy
}

testproxy() {
    curl -v google.com
}

listproxy() {
    echo $ALL_PROXY
    echo $all_proxy
    echo $https_proxy
    echo $http_proxy
}