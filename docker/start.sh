#!/bin/bash
git config --global user.name $GIT_USER_NAME
git config --global user.email $GIT_USER_MAIL

# Print information
echo ""
echo "########################################################################"
echo ""

echo ""
echo "Activate the Conda environment"
echo "-----------------------------------------------------------------"
echo "source activate ds-py3"
echo ""
echo "To get a Cookiecutter, run ..."
echo "-----------------------------------------------------------------"
echo "git clone https://github.com/dushyantkhosla/ds-template-01.git"
echo ""
echo "To start a Jupyter notebook server, run ..."
echo "-----------------------------------------------------------------"
echo "jupyter lab --allow-root --no-browser --ip 0.0.0.0"
echo ""
echo "Configure git. Run ..."
echo "-----------------------------------------------------------------"
echo "git config --global user.email 'you@example.com'"
echo "git config --global user.name 'Your Name'"
echo ""

echo "########################################################################"
echo ""
