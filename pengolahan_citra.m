clc; clear; close all; warning off all;

% SVM Pengolahan citra
% memanggil menu "browse file"
[nama_file, nama_folder] = uigetfile('*.jpg');

% jika ada file yang dipilih maka akan mengeksekusi perintah di bawah ini 
if ~isequal(nama_file,0)
    % membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file));
    figure, imshow(Img)
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
    data_uji(1,1) = Correlation;
    data_uji(1,2) = Energy;
    
    % memanggil variabel Mdl hasil pelatihan
    load Mdl

    % membaca kelas keluaran hasil pengujian 
    kelas_keluaran = predict(Mdl,data_uji);
    
    % menampilkan citra asli dan kelas keluaran hasil pengujian
    figure, imshow(Img)
    title({['Nama File: ',nama_file],['Kelas Keluaran: ',kelas_keluaran{1}]})
else
    % jika tidak ada nama file yang dipilih maka akan kembali
    return
end
    

    