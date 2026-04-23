# StripeCD
Change Representation and Extraction in Stripes: Rethinking Unsupervised Hyperspectral Image Change Detection With an Untrained Network

This repository contains the official MATLAB implementation of StripeCD, an unsupervised hyperspectral image change detection method proposed in the following paper:

B. Yang, Y. Mao, L. Liu, L. Fang and X. Liu,"Change Representation and Extraction in Stripes: Rethinking Unsupervised Hyperspectral Image Change Detection With an Untrained Network,"IEEE Transactions on Image Processing, vol. 33, pp. 5098-5113, 2024.DOI: 10.1109/TIP.2024.3438100

🚀 Quick Start: Step-by-Step Workflow  
The pipeline consists of two core steps:  
Generate untrained deep features  
Go to the UntrainedNetwork/ folder.  
Run the provided scripts to generate the dual-temporal deep features for your bi-temporal hyperspectral images.  
Save the generated features as .mat files for the next step.  
Run the StripeCD change detection algorithm  
After obtaining the .mat feature files, run the main script StripeCD.m.  
This will perform the stripe-based change representation and extraction to produce the final change detection map.  

📂 Repository Structure
text
├── proximal_operators/     # Proximal operators for optimization
├── SLIC_functions/         # SLIC superpixel segmentation functions
├── UntrainedNetwork/      # Untrained network for deep feature generation
├── admm_averS_neumann.m   # ADMM solver for the main model
├── cd_evaluation.m         # Quantitative evaluation metrics
├── extract_cmp.m          # Feature comparison and extraction utilities
├── fw_bw_fuse.m            # Forward-backward fusion functions
├── getLR.m                 # Stripe modeling
├── getPCA.m                # PCA preprocessing
├── StripeCD.m             # Main script for StripeCD
├── pca_kmeans.m            # PCA + K-means clustering
├── slicmex.mexw64          # Compiled MEX file for SLIC
└── README.md               # This file

📝 Citation
If you find this code useful in your research, please cite our paper:
bibtex
@article{yang2024changerepresentation,
  title={Change Representation and Extraction in Stripes: Rethinking Unsupervised Hyperspectral Image Change Detection With an Untrained Network},
  author={Yang, B. and Mao, Y. and Liu, L. and Fang, L. and Liu, X.},
  journal={IEEE Transactions on Image Processing},
  volume={33},
  pages={5098--5113},
  year={2024},
  publisher={IEEE},
  doi={10.1109/TIP.2024.3438100}
}

📬 Contact
If you have any questions about the code or paper, feel free to contact the authors.
