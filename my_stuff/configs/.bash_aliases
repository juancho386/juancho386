alias l="\ls -lha1 --color=always"
alias ls="\ls -lha1rt --color=always"
alias cmatrix="cmatrix -ab"

export EDITOR="vim"
export AWS_REGION_LIST="us-east-1 us-east-2 us-west-1 us-west-2 af-south-1 ap-east-1 ap-southeast-1 ap-southeast-2 ap-southeast-3 ap-northeast-1 ap-northeast-2 ap-northeast-3 ca-central-1 eu-central-1 eu-west-1 eu-west-2 eu-west-3 eu-south-1 eu-north-1 me-south-1 sa-east-1"

git_prompt() {
	t=$( git branch 2>/dev/null | sed -e '/^[^*]/d;s/* \(.*\)/\1/' )
	if [ x$t != x ]; then
		echo -e $t
	fi
}

function REGION(){
	export AWS_REGION=$(dialog --stdout --menu "AWS Region" 20 70 18 \
		eu-west-1 Irlanda \
		eu-central-1 Frankfurt \
		eu-west-2 Londres  \
		eu-south-1 Milan \
		eu-west-3 Paris  \
		eu-north-1 Estocolmo \
		us-east-1 Virginia \
		us-east-2 Ohio \
		us-west-1 California \
		us-west-2 Oregon
	);
}

win=$(echo -ne "\U229e")
PS1="\[\033[0m\]#\u@\[\033[1;41m\]\${NAMESPACE}\${AWS_PROFILE}:\[\033[1;44m\]\$( git_prompt )\[\033[0;1;33m\]:\w\[\033[0m\]:\[\033[40;1;32m\][\${PIPESTATUS[@]}]\[\033[0m\]> "

