% =========================================================================
% FILE 2: decoding.m
% PURPOSE: Decode secret message from stego image using key image
% =========================================================================

function decoding()
    clear all;
    close all;
    clc;
    
    disp('===============================================');
    disp('    LSB-XOR STEGANOGRAPHY - DECODING');
    disp('===============================================');
    
    %% Step 1: Load Images
    disp('Step 1: Loading images...');
    
    stego_image = imread('stego_image.png');
    key_image = imread('key_image.png');
    
    if size(stego_image, 3) == 3
        stego_image = rgb2gray(stego_image);
    end
    if size(key_image, 3) == 3
        key_image = rgb2gray(key_image);
    end
    
    disp('Images loaded successfully');
    
    %% Step 2: Split Stego-Image into S_Img1 and S_Img2
    disp('Step 2: Splitting Stego-Image...');
    
    stego_pixels = double(stego_image(:));
    
    % Odd positions -> S_Img1
    S_Img1 = stego_pixels(1:2:end);
    
    % Even positions -> S_Img2
    S_Img2 = stego_pixels(2:2:end);
    
    %% Step 3: Split Key-Image into S_Key_img1 and S_Key_img2
    disp('Step 3: Splitting Key-Image...');
    
    key_pixels = double(key_image(:));
    
    % Odd positions -> S_Key_img1
    S_Key_img1 = key_pixels(1:2:end);
    
    % Even positions -> S_Key_img2
    S_Key_img2 = key_pixels(2:2:end);
    
    %% Step 4: XOR to extract message bits
    disp('Step 4: Extracting message with XOR...');
    
    % Extract LSBs
    LSB_Key1 = mod(S_Key_img1, 2);
    LSB_Img1 = mod(S_Img1, 2);
    
    LSB_Key2 = mod(S_Key_img2, 2);
    LSB_Img2 = mod(S_Img2, 2);
    
    % XOR to get message bits
    m1 = xor(LSB_Key1, LSB_Img1);  % Odd bits
    m2 = xor(LSB_Key2, LSB_Img2);  % Even bits
    
    %% Step 5: Interleave bits
    disp('Step 5: Reconstructing message...');
    
    max_len = max(length(m1), length(m2));
    msg_binary = [];
    
    for i = 1:max_len
        if i <= length(m1)
            msg_binary = [msg_binary, m1(i)];
        end
        if i <= length(m2)
            msg_binary = [msg_binary, m2(i)];
        end
    end
    
    %% Step 6: Convert binary to text
    num_chars = floor(length(msg_binary) / 8);
    decoded_message = '';
    
    for i = 1:num_chars
        % Get 8 bits
        start_idx = (i-1)*8 + 1;
        char_bits = msg_binary(start_idx:start_idx+7);
        
        % Reverse bits
        char_bits = fliplr(char_bits);
        
        % Convert to ASCII
        bin_str = num2str(char_bits);
        bin_str = strrep(bin_str, ' ', '');
        ascii_val = bin2dec(bin_str);
        
        if ascii_val == 0
            break;
        end
        
        decoded_message = [decoded_message, char(ascii_val)];
    end
    
    %% Step 7: Display result
    disp('===============================================');
    disp('DECODED MESSAGE:');
    disp(['   "' decoded_message '"']);
    disp('===============================================');
    
    % Display images
    figure('Name', 'Decoding Result');
    subplot(1,2,1);
    imshow(key_image);
    title('Key Image');
    
    subplot(1,2,2);
    imshow(stego_image);
    title('Stego Image');
    
    disp('DECODING COMPLETED!');
end
