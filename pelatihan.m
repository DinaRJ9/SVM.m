clc; clear; close all; warning off all;

% SVM Pelatihan
% menetapkan nama folder
nama_folder = 'data latih';
% membaca nama file yang berektensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
% membaca jumlah file yang berektensi .jpg
jumlah_file = numel(nama_file);

% menginisialisasi variabel data latih
data_latih = zeros(jumlah_file,2);

% melakukan pengolahan citra terhadap seluruh file
for k = 1:jumlah_file
    % membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file(k).name));
  %  figure, imshow(Img)
    % mengkonversi citra rgb menjadi citra graycale
    Img_gray = rgb2gray(Img);
  %  figure, imshow(Img_gray)
    % melakukan ekstraksi ciri tektur menggunakan metode GLCM
    pixel_dist = 1;
    GLCM = graycomatrix(Img_gray,'Offset',[0 pixel_dist;
        -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);
    stats = graycoprops(GLCM,'correlation','energy');
    
    Correlation = mean(stats.Correlation);
    Energy = mean(stats.Energy);
    
    % menyusun variabel data_latih
    data_latih(k,1) = Correlation;
    data_latih(k,2) = Energy;
    
end

% menetapkan target_latih
target_latih = cell(jumlah_file,1);
for k = 1:5
    target_latih{k} = 'cupang';
end

for k = 6:10
    target_latih{k} = 'guppy';
end

% melakukan pelatihan menggunakan algoritma SVM
Mdl = fitcsvm(data_latih,target_latih);

% membaca kelas keluaran hasil pelatihan 
kelas_keluaran = predict(Mdl,data_latih);

% menghitung akurasi pelatihan
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal(kelas_keluaran{k},target_latih{k})
        jumlah_benar = jumlah_benar+1;
    end
end

akurasi_pelatihan = jumlah_benar/jumlah_file*100

% menyimpan variabel Mdl hasil pelatihan
save Mdl Mdl