#!/usr/bin/python
import os
import json
import argparse
import http.client
from getpass import getpass
import urllib.parse
from datetime import datetime
import socket

DEBUG = False

def guacamole_login(connection, path, user, password):
    payload = urllib.parse.urlencode({'username' : user, 'password' : password})
    headers = {'Content-Type': 'application/x-www-form-urlencoded'}
    connection.request("POST", path+"api/tokens", payload, headers)
    res = connection.getresponse()
    httpStatusCode = res.status
    msg = res.read()  # whole response must be readed in order to do more requests using the same connection
    if httpStatusCode != 200:
        print('Login error. Code: %d %s' % (httpStatusCode, res.reason))
        print(msg)
        return ''
    else:
        print('Login success.')
        response = json.loads(msg)
        #print(response)
        return response['authToken']

def getConnectionGroupId(connection, path, token, user):
    payload = ''
    headers = {}
    connection.request("GET", path+"api/session/data/postgresql/connectionGroups/ROOT/tree?token="+token, payload, headers)
    res = connection.getresponse()
    httpStatusCode = res.status
    msg = res.read()  # whole response must be readed in order to do more requests using the same connection
    if httpStatusCode != 200:
        print('Error getting connection group id. Code: %d %s' % (httpStatusCode, res.reason))
        print(msg)
        return -1
    else:
        response = json.loads(msg)
        #print(response)
        groupId = 'ROOT'
        for group in response['childConnectionGroups']:
            if group['name'] == user: 
                groupId = group['identifier']
        if groupId == 'ROOT':
            print('Connection group for '+user+' not found. Using '+groupId+'.')
        else:
            print('Connection group id for '+user+' is '+groupId+'.')
        return groupId

def createVncConnection(connection, path, token, connectionName, connectionGroupId, guacd_hostname, myIP, vnc_port, vnc_password, sftp_user, sftp_password):
    newConnection = {
        "name": connectionName,
        "parentIdentifier": connectionGroupId,
        "protocol": "vnc",

        "attributes": {
            "max-connections": "",
            "max-connections-per-user": "",

            "weight": "",
            "failover-only": "",

            "guacd-hostname": guacd_hostname,
            "guacd-port": 4822,
            "guacd-encryption": "",
        },
        "parameters": {
            "hostname": myIP, # "10.109.148.247",
            "port": vnc_port,

            "password": vnc_password,

            "read-only": "",
            "swap-red-blue": "",
            "cursor": "",
            "color-depth": "",
            "clipboard-encoding": "",
            
            "dest-port": "",
            "recording-exclude-output": "",
            "recording-exclude-mouse": "",
            "recording-include-keys": "",
            "create-recording-path": "",

            "enable-sftp": "true",
            "sftp-hostname": myIP,
            "sftp-port": "22",
            "sftp-root-directory": "/",
            "sftp-username": sftp_user,
            "sftp-password": sftp_password,
            "sftp-server-alive-interval": "",

            "enable-audio": ""
        }
    }
    payload = json.dumps(newConnection)
    if DEBUG: print(payload)
    headers = {'Content-Type': 'application/json;charset=UTF-8'}
    connection.request("POST", path+"api/session/data/postgresql/connections?token="+token, payload, headers)
    res = connection.getresponse()
    httpStatusCode = res.status
    msg = res.read()  # whole response must be readed in order to do more requests using the same connection
    if httpStatusCode != 200:
        print('Error creating the connection. Code: %d %s' % (httpStatusCode, res.reason))
        print(msg)
        return False
    else:
        #print('.', end='')
        return True
    
       

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='This script creates a connection for localhost VNC service in the guacamole API-REST endpoint provided.',
                                    epilog='Example of use: \n'
                                               + '  python '+os.path.basename(__file__)+' --url https://chaimeleon-eu.i3m.upv.es/guacamole/ --user guacamoleUser '
                                               + '--guacd-host 10.111.51.93 --vnc-password somePassword --sftp-user tensor --sftp-password somePassword2 --debug')
    parser.add_argument('--url', type=str, required=True, help='Guacamole endpoint URL. Example: https://chaimeleon-eu.i3m.upv.es/guacamole/')
    parser.add_argument('--user', type=str, required=True, help='User for the Guacamole API-REST endpoint login')
    parser.add_argument('--password', type=str, default='..........', help='Password for the Guacamole API-REST endpoint login (you should have a user in guacamole database with a not empty password). ' 
                                                                         + 'May be you can access to Guacamole web page using an OIDC account, in that case the password probably is not the same. '
                                                                         + '(if --password is not set, it will be interactively asked)')
    parser.add_argument('--connection-name', type=str, default='date', help='Optional name for the new conection. If not provided, it will be generated from the current date.')
    parser.add_argument('--guacd-host', type=str, required=True)
    parser.add_argument('--vnc-password', type=str, required=True)
    parser.add_argument('--sftp-user', type=str, required=True)
    parser.add_argument('--sftp-password', type=str, required=True)
    parser.add_argument('--debug', action='store_true', help='Write debug details in the standard output')
    args = parser.parse_args()
    DEBUG = args.debug
    
    url = urllib.parse.urlparse(args.url)
    port = url.port
    if url.scheme == 'http':
        if port == None: port = 80
        connection = http.client.HTTPConnection(url.hostname, port) 
    else:
        if port == None: port = 443
        connection = http.client.HTTPSConnection(url.hostname, port)

    password = args.password
    if password == '..........':
        password = getpass("Password for "+args.user+ " in Guacamole: ")

    
    print('Connecting to '+args.url+ 'api/')
    token = guacamole_login(connection, url.path, args.user, password)

    if token=='': exit(code=1)

    ret = getConnectionGroupId(connection, url.path, token, args.user)
    if ret==-1:
        exit(code=2)
    connectionGroupId = ret

    myIP = socket.gethostbyname(socket.gethostname())
    vnc_port = "5900"
    print('Creating VNC connection for '+myIP+':'+vnc_port)
    connectionName = "pod-deployed-on-"+datetime.today().strftime('%Y-%m-%d-%H:%M:%S') if args.connection_name == 'date' else args.connection_name
    ret = createVncConnection(connection, url.path, token, connectionName, connectionGroupId, args.guacd_host, myIP, vnc_port, args.vnc_password, args.sftp_user, args.sftp_password )
    if ret==False:
        exit(code=3)
            
    print('Done.')
    exit(code=0)

