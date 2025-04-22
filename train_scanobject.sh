#!/bin/bash

# Define variables for the folds (choices) and pooling algorithms
choices=(0)  # Replace with actual fold numbers if different
poolings=("attention" "additive" "conjunctive" "instance" "gap")  # Replace with actual pooling options

# Original YAML file
config_file="cfgs/scanobjectnn/dgcnn_mil.yaml"
output_dir="cfgs/scanobjectnn/"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop over each choice and pooling algorithm
for pooling in "${poolings[@]}"; do
  for choice in "${choices[@]}"; do

    # Generate a unique config file for this combination
    modified_config="${output_dir}/dgcnn_mil_final_scanobjectnn_${choice}_pooling_${pooling}.yaml"
    cp "$config_file" "$modified_config"

    # Modify the YAML file with the current choice and pooling
    sed -i "s/choice: [0-9]\+/choice: $choice/" "$modified_config"
    sed -i "s/pooling: .*/pooling: $pooling/" "$modified_config"

    # Define a unique log file and results directory for this run
    run_log="${output_dir}/dgcnn_mil_scanobjectnn_${choice}_pooling_${pooling}.log"

    # Run the training script with the modified config
    echo "Training for choice=$choice and pooling=$pooling"
    CUDA_VISIBLE_DEVICES=0 python examples/classification/main.py --cfg "$modified_config" > "$run_log"

    echo "Training completed for choice=$choice and pooling=$pooling. Results saved to $run_log"
  done
done
