
% FILE 1: encoding.m
% PURPOSE: Encode secret message into key image

function encoding()
    close all;
    clc;
    
    disp('===============================================');
    disp('    LSB-XOR STEGANOGRAPHY - ENCODING');
    disp('===============================================');
    
    %% Step 1: Load Stego-Key-Image
    disp('Step 1: Loading Stego-Key-Image...');
    key_image = imread('lena.png');  % Change to your image

    % Convert to grayscale
    if size(key_image, 3) == 3 % As three channel, RGB
        key_image = rgb2gray(key_image);
    end
    
    [rows, cols] = size(key_image);
    disp(['Image loaded: ' num2str(rows) ' x ' num2str(cols)]);
    
    %% Step 2: Image Sharing - Split into S_Key_img1 and S_Key_img2
    disp('Step 2: Splitting key image into two shares...');
    
    % Flatten image to vector, Flattens the image (row-major) to a column vector
    key_pixels = double(key_image(:));
    
    % Odd positions -> S_Key_img1
    S_Key_img1 = key_pixels(1:2:end);
    
    % Even positions -> S_Key_img2
    S_Key_img2 = key_pixels(2:2:end);
    
    disp(['S_Key_img1 (odd): ' num2str(length(S_Key_img1)) ' pixels']);
    disp(['S_Key_img2 (even): ' num2str(length(S_Key_img2)) ' pixels']);
    
    %% Step 3: Prepare Secret, Reads a string to hide.
    secret_message = input('Enter secret message: ', 's');
    if isempty(secret_message)
        secret_message = 'I';  % Default from paper
    end
    
    disp(['Secret Message: "' secret_message '"']);
    
    %% Step 4: Convert message to binary and split
    disp('Step 3: Converting message to binary...');
    
    msg_binary = [];
    for i = 1:length(secret_message)
        ascii_val = double(secret_message(i));
        bin_str = dec2bin(ascii_val, 8);
        
        % Reverse the binary string
        bin_str = fliplr(bin_str); % Flip array left to right

        % Add to message binary
        for j = 1:8
            msg_binary = [msg_binary, str2double(bin_str(j))];
        end
    end
    
    % Split message into odd and even positions
    S_Msg1 = msg_binary(1:2:end);  % Odd
    S_Msg2 = msg_binary(2:2:end);  % Even
    
    disp(['Total bits: ' num2str(length(msg_binary))]); % num2str = This MATLAB function converts a numeric array into a character array that represents the numbers.
    disp(['S_Msg1 (odd): ' num2str(length(S_Msg1)) ' bits']);
    disp(['S_Msg2 (even): ' num2str(length(S_Msg2)) ' bits']);
    
    %% Step 5: XOR Operation with LSBs
    disp('Step 4: Performing XOR operation...');
    
    % Extract LSBs from S_Key_img1
    % Take each pixel value in S_Key_img1 and compute remainder mod 2
    % For any integer pixel p, mod(p,2) is 0 if p is even, 1 if p is odd —> i.e., The least significant bit (LSB)
    LSB_Key1 = mod(S_Key_img1, 2);
    
    % XOR with S_Msg1
    i1 = xor(LSB_Key1(1:length(S_Msg1)), S_Msg1');
    
    % Replace LSB in S_Key_img1
    S_Img1 = S_Key_img1;
    for idx = 1:length(i1)
        S_Img1(idx) = floor(S_Key_img1(idx)/2)*2 + i1(idx);
    end
    
    % Extract LSBs from S_Key_img2
    LSB_Key2 = mod(S_Key_img2, 2);
    
    % XOR with S_Msg2
    i2 = xor(LSB_Key2(1:length(S_Msg2)), S_Msg2');
    
    % Replace LSB in S_Key_img2
    S_Img2 = S_Key_img2;
    for idx = 1:length(i2)
        S_Img2(idx) = floor(S_Key_img2(idx)/2)*2 + i2(idx);
    end
    
    disp('XOR completed on both shares');
    
    %% Step 6: Merge to create Stego-Image
    disp('Step 5: Creating Stego-Image...');
    
    total_pixels = rows * cols;
    stego_vector = zeros(total_pixels, 1);
    
    % Merge odd and even positions
    msg_pixels = length(S_Msg1) + length(S_Msg2);
    
    for i = 1:msg_pixels
        if mod(i, 2) == 1  % Odd position
            stego_vector(i) = S_Img1(ceil(i/2)); % Ceil, This MATLAB function rounds each element of X to the nearest integer greater than or equal to that element.
        else  % Even position
            stego_vector(i) = S_Img2(i/2);
        end
    end
    
    % Copy remaining pixels unchanged
    for i = (msg_pixels+1):total_pixels
        if mod(i, 2) == 1
            idx = ceil(i/2);
            if idx <= length(S_Key_img1)
                stego_vector(i) = S_Key_img1(idx);
            end
        else
            idx = i/2;
            if idx <= length(S_Key_img2)
                stego_vector(i) = S_Key_img2(idx);
            end
        end
    end
    
    % Reshape to image
    stego_image = uint8(reshape(stego_vector, rows, cols));
    
    %% Step 7: Save and display
    imwrite(stego_image, 'stego_image.png');
    imwrite(key_image, 'key_image.png');
    
    disp('✓ Stego-Image saved as: stego_image.png');
    disp('✓ Key-Image saved as: key_image.png');
    
    % Display
    figure('Name', 'Encoding Result');
    subplot(1,3,1);
    imshow(key_image);
    title('Stego-Key-Image');
    
    subplot(1,3,2);
    imshow(stego_image);
    title('Stego-Image');
    
    subplot(1,3,3);
    diff = abs(double(stego_image) - double(key_image));
    imshow(diff*50, []);
    title('Difference (Enhanced)');
    colorbar;
    
    % Statistics
    disp('===============================================');
    disp('STATISTICS:');
    fprintf('Message Length: %d characters\n', length(secret_message));
    fprintf('Bits Embedded: %d\n', length(msg_binary));
    fprintf('Max Pixel Change: %d\n', max(diff(:)));
    fprintf('PSNR: %.2f dB\n', psnr(stego_image, key_image));
    disp('===============================================');
    disp('ENCODING COMPLETED!');
end
