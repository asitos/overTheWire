function otw-grab --description 'Fetch password from OTW, save locally, and log to README'
    set -l level $argv[1]
    set -l remote_cmd $argv[2]
    set -l next_level (math $level + 1)
    
    set -l project_dir "$HOME/Projects/overTheWire"
    set -l pass_file "$project_dir/passwords/bandit$level.txt"
    set -l save_file "$project_dir/passwords/bandit$next_level.txt"
    set -l log_file "$project_dir/README.md"

    if test -f $pass_file
        set -l password (cat $pass_file | string trim)
        set -l user "bandit$level"

        echo "Running '$remote_cmd' on $user..."
        
        # Connect, run the command, and pipe the output locally
        sshpass -p $password ssh "$user@otw" "$remote_cmd" > $save_file
        
        # Check if the file actually got data (didn't fail)
        if test -s $save_file
            echo "Successfully saved to bandit$next_level.txt"
            
            # Append the solution to your Markdown file
            if not test -f $log_file
                echo "# OverTheWire bandit solutions" > $log_file
                echo "my command-line solutions for the Bandit wargame." >> $log_file
                echo "" >> $log_file
            end
            
            echo "### level $level -> level $next_level" >> $log_file
            echo "\`\`\`bash" >> $log_file
            echo "$remote_cmd" >> $log_file
            echo "\`\`\`" >> $log_file
            echo "" >> $log_file
            
            echo "solution logged to readme.md!"
        else
            echo "Command failed or returned empty. Password not saved."
        end
    else
        echo "Error: Could not find $pass_file to authenticate."
    end
end
