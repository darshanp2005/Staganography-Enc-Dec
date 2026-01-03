
function main()
    clc;
    disp('===============================================');
    disp('  LSB-XOR STEGANOGRAPHY WITH IMAGE SHARING');
    disp('===============================================');
    disp('1. Encode (Hide message in image)');
    disp('2. Decode (Extract message from image)');
    disp('===============================================');
    
    choice = input('Enter your choice (1 or 2): ');
    
    if choice == 1
        encoding();
    elseif choice == 2
        decoding();
    else
        disp('Invalid choice!');
    end
end