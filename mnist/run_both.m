%% Run all MNIST related experiments
cd cnn;
run run_all.m;

cd ..;
cd ffnn;
run run_all.m;

cd ..
run create_table.m;