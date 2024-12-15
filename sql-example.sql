sqlite3 /usr/lib/ipsec/ipsec.db "
SELECT name FROM sqlite_master WHERE type='table';
" | while read table; do   echo -n "$table: ";   sqlite3 /usr/lib/ipsec/ipsec.db "SELECT COUNT(*) FROM $table;"; done



sqlite3 /usr/lib/ipsec/ipsec.db "SELECT * FROM identities;"