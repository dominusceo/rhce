#! /bin/bash
kadmin.local  -q "addprinc -randkey host/guest.example.com" -p admin@EXAMPLE.COM
kadmin.local  -q "addprinc -randkey host/desktop.example.com" -p admin@EXAMPLE.COM
