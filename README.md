# preserve_comments_cockroachdb

This demo script shows a way to save the comments on the objects in one database (such as table comments).
Then you can apply these saved comments to corresponding objects in another database.

This was created because, currently in CockroachDB, the only way for comments to be restored after BACKUP and RESTORE is to perform a _cluster_ backup followed by a _cluster_ restore.
If restoring just a database or a table, the comments are lost.

This issue is tracked in GitHub issue 
[#44396](https://github.com/cockroachdb/cockroach/issues/44396) "backupccl: backup/restore does not handle comments"

## To Run

To run this demo:

- Make sure the `cockroach` command is in your shell command line path.  You can download CockroachDB
[here](https://www.cockroachlabs.com/docs/releases).
- Make sure the `zsh` shell is available on your system in a standard location
- Run the `comment_test_setup.sql` script
- Press `RETURN` to step through the script

## Cleanup After Running

To clean up:

- Kill the three `cockroach start` processes
- Delete the three CockroachDB data directories (named node1, node2, and node3)
- Delete comments.csv

## Sample Run with Output

You don't actually have to run this demo to see what it does.  You can examine this 
[output of a sample run](sample_output.md).
