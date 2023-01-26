clc; clear; close all; warning off all;

% SVM Pengujian
% menetapkan nama folder
nama_folder = 'data uji';
% membaca nama file yang berektensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
% membaca jumlah file yang berektensi .jpg
jumlah_file = numel(nama_file);

% menginisialisasi variabel data latih
data_uji = zeros(jumlah_file,2);

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
    
    % menyusun variabel data_uji
    data_uji(k,1) = Correlation;
    data_uji(k,2) = Energy;
    
end

% menetapkan target_uji
target_uji = cell(jumlah_file,1);
for k = 1:3
    target_uji{k} = 'cupang';
end

for k = 4:6
    target_uji{k} = 'guppy';
end

% memanggil variabel Mdl hasil pelatihan
load Mdl

% membaca kelas keluaran hasil pengujian 
kelas_keluaran = predict(Mdl,data_uji);

% menghitung akurasi pengujian
jumlah_benar = 0;
for k = 1:jumlah_file
    if isequal(kelas_keluaran{k},target_uji{k})
        jumlah_benar = jumlah_benar+1;
    end
end

akurasi_pengujian = jumlah_benar/jumlah_file*100
