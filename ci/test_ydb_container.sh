#!/bin/bash
#################################################################
#								#
# Copyright (c) 2022 YottaDB LLC and/or its subsidiaries.	#
# All rights reserved.						#
#								#
#	This source code contains the intellectual property	#
#	of its copyright holder(s), and is made available	#
#	under a license.  If you do not know the terms of	#
#	the license, please stop and do not read further.	#
#								#
#################################################################
set -e
set -o pipefail

mkdir build
cd build
cmake ../test
make && make install

echo "Running M mode code..."
export ydb_chset="M"
. /opt/yottadb/current/ydb_env_set
echo $ydb_routines
yottadb -r test1
yottadb -r test2
. /opt/yottadb/current/ydb_env_unset

echo "Running UTF-8 mode code..."
export ydb_chset="UTF-8"
. /opt/yottadb/current/ydb_env_set
echo $ydb_routines
yottadb -r test1
yottadb -r test2
. /opt/yottadb/current/ydb_env_unset
