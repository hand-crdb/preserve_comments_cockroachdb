#!/bin/zsh

# ^^^^^^^^ note zsh not sh or bash
#
# This is needed to get HERE documents to work correctly
# when lines in the document end with a backslash
#
# Zsh correctly does not join lines in a HERE document that end in a backslash
# Bash incorrectly joins lines in a HERE document that end in a backslash

#####################################################################
# Demo for saving and restoring object comments across BACKUP/RESTORE
#####################################################################

# Set options for better shell script behavior
# Per https://gist.github.com/mohanpedala/1e2ff5661761d3abd0385e8223e16425
#
# The set -e option instructs bash to immediately exit 
# if any command has a non-zero exit status.
#
# When -u is set, a reference to any variable you haven't previously 
# defined - with the exceptions of $* and $@ - is an error, and causes 
# the program to immediately exit.
#
# The -o pipefail setting prevents errors in a pipeline from being masked. 
# If any command in a pipeline fails, that return code will be used as 
# the return code of the whole pipeline. 
set -euo pipefail

# Uncomment to turn on shell tracing
# set -x

# Variable definitions
# NOTE: You must expoert Variables that will be displayed expanded in displayed commands

TEXT_WIDTH="100"
STAGE=1
TOTALSTAGES="3"
BOLD=$(tput bold)
NOBOLD=$(tput sgr0)

if [[ "${1:-}" == "--nopause" ]]; then
  NOPAUSE=1
  else
  NOPAUSE=0
fi

pause() {
  PAUSE_TEXT="⏸️   Press [Enter] to execute this step..."
  if [[ $# -ne 0 ]]; then
    PAUSE_TEXT="✅   Press [Enter] to continue to the next step..."
  fi
 
  if [[ $NOPAUSE == "1" ]]; then
      sleep 1
    else
#USE THIS FOR BASH NOT KSH#      read -p "${PAUSE_TEXT}" 
      read "?${PAUSE_TEXT}" 
  fi
  echo
}

print_text() {
  if [ -n "$1" ]; then
    echo "🛠️  $1" | fold -s -w $TEXT_WIDTH
  fi
}

# Print the command to be executed
# Print it with a single blank line before and after the command
# If the command already has any blank lines before or after the command, remove them.
# Blank lines are either empty lines or lines that only contain whitespace
# ref: https://stackoverflow.com/questions/12524308/bash-strip-trailing-linebreak-from-output
print_cmd() {
  param=$1
  trailing_space_removed=${param%[[:space:]]}
  leading_and_trailing_space_removed=${trailing_space_removed##[[:space:]]}
  echo
  echo "${BOLD}${leading_and_trailing_space_removed}${NOBOLD}" | envsubst $2
  echo
}

print_title() {
  echo "🚀 [$STAGE/$TOTALSTAGES] $1..."
  echo
  ((STAGE++))
}

# Parameters:
# 1: The stage title or empty string
# 2: Text to describe the current step or empty string
# 3: Command to display and execute or empty string
#    The command may have leading or trailing blank lines
#    (where a blank line is either an empty line or a line of only whitespace)
#    The command may be multi-line, using backslash at the end of line as a continuation character
#    The command may have environment variable references in it
#    Note: Variable references, if any, should be environment variables not local shell variables
# 4: List of environment variables to be substituted, or the word "noexpand"
#    The list is in the form $VAR1:$VAR2:$VAR3 including dollar signs (so enclose in single quotes).
#    Any environment variables not listed will not be expanded in the displayed command
# 5: [OPTIONAL] Whether to pause after displaying the command and before running it.
#    To not pause at all, specify "nopause"
#    To just pause after execution, specify "pause_after"
#    To pause both before and after execution, do not specify this parameter at all
do_stage() {
  if [[ -n "$1" ]]; then
    print_title "$1"
  fi  
  if [[ -n "$2" ]]; then
    print_text "$2"
  fi
  echo
  if [[ -n "$3" ]]; then
    echo "Next command:"
    echo "------------"
    print_cmd "$3" "$4"
    if [[ $# -ne 5 ]]; then
        pause
    fi
    echo "---Running"
    eval "$3" 
    echo "---Done"
    echo
    if [[ $# -ne 5 ]]; then
        pause post_icon
    elif [[ "$5" == "pause_after" ]]; then
        pause post_icon
    fi
  fi
}


######################################################################################################
###################################### DEMO START ####################################################
######################################################################################################

echo
echo "DEMO START"
echo

TITLE='Start a local 3-node CockroachDB cluster'
TEXT='Start the first node'
CMD=$(cat <<'EOFHERE'
 cockroach start \
  --insecure \
  --store=node1,ballast-size=0 \
  --listen-addr=localhost:26257 \
  --http-addr=localhost:8080 \
  --join=localhost:26257,localhost:26258,localhost:26259 \
  --background
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" ''

TEXT='Start the second node'
CMD=$(cat <<'EOFHERE'
 cockroach start \
  --insecure \
  --store=node2,ballast-size=0 \
  --listen-addr=localhost:26258 \
  --http-addr=localhost:8081 \
  --join=localhost:26257,localhost:26258,localhost:26259 \
  --background
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" ''

TEXT='Start the third node'
CMD=$(cat <<'EOFHERE'
 cockroach start \
  --insecure \
  --store=node3,ballast-size=0 \
  --listen-addr=localhost:26259 \
  --http-addr=localhost:8082 \
  --join=localhost:26257,localhost:26258,localhost:26259 \
  --background
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" ''

TEXT='Initialize the cluster'
CMD=$(cat <<'EOFHERE'
 cockroach init --insecure --host=localhost:26257
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" ''

TEXT='Show the comments on all database objects'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -e "
    SET allow_unsafe_internals = true;
    SELECT * from system.comments ORDER BY type, object_id, sub_id"
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TITLE='Set up the demo schema with comments on database objects'
TEXT='Load the schema'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure --echo-sql -f comment_test_setup.sql
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TEXT='Show the comments on all database objects'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -e "
    SET allow_unsafe_internals = true;
    SELECT * from system.comments ORDER BY type, object_id, sub_id"
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TITLE='Save the comments to a CSV file'

TEXT='Save the comments'
CMD=$(cat <<'EOFHERE'
 cockroach sql -d comment_test --insecure --echo-sql -f show_comments_all_objects.sql --format csv | \
   tail -n +2 > comments.csv
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TEXT='Look at the saved comments'
CMD=$(cat <<'EOFHERE'
   cat comments.csv
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TITLE='Create the golden master backup'
TEXT='Backup to a local directory'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -e "BACKUP DATABASE comment_test INTO 'nodelocal://1/comments_test_backup'"
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TITLE='Drop the golden master database'
TEXT=''
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -e "
    SET sql_safe_updates = false; 
    DROP DATABASE comment_test"
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TITLE='Restore the golden master backup to a new database'
TEXT='Restore from local file'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -e "RESTORE DATABASE comment_test FROM LATEST IN 'nodelocal://1/comments_test_backup' WITH new_db_name = 'newdb'"
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TEXT='Show the comments on all database objects'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -e "
    SET allow_unsafe_internals = true;
    SELECT * from system.comments ORDER BY type, object_id, sub_id"
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TITLE='Make the saved comments available for IMPORT'
TEXT='Copy CSV file to where it can be imported as a local file'
CMD=$(cat <<'EOFHERE'
 cp -i comments.csv node1/extern
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TITLE='Import the saved comments to a working table'

TEXT='Create the working table'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -d newdb --echo-sql -f create_table_database_object_comments.sql
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TEXT='IMPORT from a local file'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -d newdb -e "IMPORT INTO database_object_comments CSV DATA ('nodelocal://1/comments.csv') WITH skip = '1'"
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TEXT='Update the working table to match the name of the new database'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -d newdb -e "
    SET sql_safe_updates = false; 
    UPDATE database_object_comments 
     SET object_database_name = 'newdb'; 
    UPDATE database_object_comments 
     SET object_name = 'newdb' 
     WHERE comment_type_name='Database';"
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TITLE='Restore the comments to the database objects'
TEXT='Generate statements to set the comments, and execute them for the database objects'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -d newdb --echo-sql -f "generate_comment_statements.sql" | \
    tail -n +2 | \
    while read stmt; do; echo "executing: $stmt"; cockroach sql --insecure -d newdb -e "$stmt"; done
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

TEXT='Show the comments on all database objects'
CMD=$(cat <<'EOFHERE'
 cockroach sql --insecure -e "
    SET allow_unsafe_internals = true;
    SELECT * from system.comments ORDER BY type, object_id, sub_id"
EOFHERE
)
do_stage "$TITLE" "$TEXT" "$CMD" '$MYSQL_VERSION'

echo
echo "DEMO FINISHED"
echo
