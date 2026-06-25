%
% Copyright (c) 2026
% All rights reserved. Please read the "license.txt" for license terms.
%
% Artifact: run_cnn2040_test.m
% Version:  1.0
% Date:     2026-04-16
% Author:   Miguel Angel Gil Rios (mgil.utleon@gmail.com)
% Comments: This script load a pre-trained lightweight CNN model 
%           consisting of 10 layers and 2040 trainable parameters focused 
%           in the classification of positive and negative mistletoe cases.
%           After the model is loaded, a test image database 
%           (provided with this code), is used to measure the 
%           classification performance of the model.
% 
close all;
clear variables;
clc;

load('cnn2040_trained.mat');

datadir_testing          = '../imagedb/';
dataset_mistletoe_testing = imageDatastore(datadir_testing, ...
                                  "IncludeSubfolders", true, ...
                                  "LabelSource", "foldernames");

% Remove the parameter Plots="none" if you want to see the visual
% representation of the CNN model:
cnn_info = analyzeNetwork(cnnmodel, Plots="none");


labels_original_test = dataset_mistletoe_testing.Labels;
scores_test = minibatchpredict(cnnmodel_trained, dataset_mistletoe_testing);
[~, idx] = max(scores_test, [], 2);
classNames = categories(labels_original_test);
labels_predicted_test = categorical(classNames(idx));

cm = confusionmat(labels_original_test, labels_predicted_test);

tn = cm(1, 1);
tp = cm(2, 2);
fp = cm(2, 1);
fn = cm(1, 2);

acc     = (tp + tn) / (tp + tn + fp + fn);
presci  = tp / (tp + fp);
recall  = tp / (tp + fn);
jaccard = tp / (tp + fp + fn);
f1s     = (2 * presci * recall) / (presci + recall);

fprintf('Accuracy:  %0.4f\n', acc);
fprintf('Precision: %0.4f\n', presci);
fprintf('Recall:    %0.4f\n', acc);
fprintf('F1 Score:  %0.4f\n', f1s);
fprintf('Jaccard:   %0.4f\n', jaccard);
fprintf('Number of Trainable Parameters: %d\n', cnn_info.TotalLearnables);