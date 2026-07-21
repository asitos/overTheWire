function otw --description 'Login to OverTheWire Bandit levels'
    set -l level $argv[1]
    set -l pass_file "$HOME/Projects/overTheWire/passwords/bandit$level.txt"

    if test -f $pass_file
        set -l password (cat $pass_file | string trim)
        set -l user "bandit$level"

        # DEBUG LINE:
        echo "DEBUG: Running -> sshpass -p [HIDDEN] ssh $user@otw"

        sshpass -p $password ssh "$user@otw"
    else
        echo "Password file not found at: $pass_file"
    end
end
