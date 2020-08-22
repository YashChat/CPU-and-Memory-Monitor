#!/bin/bash

#DO NOT REMOVE THE FOLLOWING TWO LINES
git add $0 >> .local.git.out
git commit -a -m "Lab 2 commit" >> .local.git.out
git push >> .local.git.out || echo


# Your code here
# printf"\n-----------Password Checker-----------\n"

password_strength=0
password=$(<$1)

# Calculate length of variable - PASSWORD
pass_length=${#password}

# Greater then ->               -gt
# Greater then or equal to ->   -ge
# Less the ->                   -lt
# Less then or equal to ->      -le
# Equal to ->                   -eq
# Not equal to ->               -ne
if [ $pass_length -gt 32 ] || [ $pass_length -lt 6 ]; then
        echo "Error: Password length invalid."
        exit;
        #echo "Password Score: $password_strength" 
fi

# To prevent output from egrep use it with -q option

# For any valid password +1 point for each character in the string
let password_strength=password_strength+pass_length;
#echo "Password Score: $password_strength" 

# If the password contains one of the following special characters (#$+%@)
if egrep -q [#$\+%@] <<< $password; then
        let password_strength=password_strength+5;
#       echo "Password Score: $password_strength" 
fi

# If the password contains at least one number (0-9)
if egrep -q [0-9] <<< $password; then
        let password_strength=password_strength+5;
#       echo "Password Score: $password_strength" 
fi

# If the password contains at least one alpha character (A-Za-z)
if egrep -q [A-Za-z] <<< $password; then
        let password_strength=password_strength+5;
#       echo "Password Score: $password_strength" 
fi

# If the password contains a repeated alphanumeric character (i.e. aa, bbb, 55555)
if egrep -q '([[:alnum:]])\1' <<< $password; then
        let password_strength=password_strength-10;
#       echo "Password Score: $password_strength" 
fi

# If the password contains 3 or more consecutive lowercase characters (i.e. bbb, abe, this)
if egrep -q [a-z][a-z][a-z] <<< $password; then
        let password_strength=password_strength-3;
#       echo "Password Score: $password_strength" 
fi

# If the password contains 3 or more consecutive uppercase characters (i.e. BBB, XQR, APPLE)
if egrep -q [A-Z][A-Z][A-Z] <<< $password; then
        let password_strength=password_strength-3;
#       echo "Password Score: $password_strength" 
fi

# If the password contains 3 or more consecutive numbers (i.e. 55555, 1747, 123, 321)
if egrep -q [0-9][0-9][0-9] <<< $password; then
        let password_strength=password_strength-3;
#       echo "Password Score: $password_strength" 
fi

echo "Password Score: $password_strength" 
