#!/bin/bash

git config --global user.name $GIT_USER_NAME
git config --global user.email $GIT_USER_MAIL

# Print information
echo ""
echo ""
echo ""
echo "To get the data, cd into the data/ directory and run:"
echo "-----------------------------------------------------------------"
echo "bash get-csvs.sh"
echo "python make-data.py"
echo ""
echo "Start the fish shell"
echo "-----------------------------------------------------------------"
echo "fish"
echo "source (conda info --root)/etc/fish/conf.d/conda.fish"
echo ""
echo "Activate the Conda environment"
echo "-----------------------------------------------------------------"
echo "conda activate ds-py3"
echo ""
echo "To start a Jupyter notebook server, run ..."
echo "-----------------------------------------------------------------"
echo "jupyter lab --allow-root --no-browser --ip 0.0.0.0"
echo ""
echo ""
echo ""
