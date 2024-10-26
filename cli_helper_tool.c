#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

void print_usage(const char *prog_name) {
    fprintf(stderr, "Usage: %s [-s] [-t] <filename> | [-c] <operation> <num1> <num2>\n", prog_name);
    fprintf(stderr, "Options:\n");
    fprintf(stderr, "  -s          Display file size\n");
    fprintf(stderr, "  -t          Display file type\n");
    fprintf(stderr, "  -c          Calculator mode\n");
    fprintf(stderr, "Calculator Operations:\n");
    fprintf(stderr, "  and         Bitwise AND\n");
    fprintf(stderr, "  or          Bitwise OR\n");
    fprintf(stderr, "  xor         Bitwise XOR\n");
    fprintf(stderr, "  shl         Shift left\n");
    fprintf(stderr, "  shr         Shift right\n");
    fprintf(stderr, "  bin         Convert to binary\n");
    fprintf(stderr, "  hex         Convert to hexadecimal\n");
    fprintf(stderr, "  dec         Convert to decimal\n");
    fprintf(stderr, "  mask        Generate a mask for specified indices or ranges\n");
    fprintf(stderr, "  log2        Logarithm base 2\n");
    fprintf(stderr, "  log10       Logarithm base 10\n");
    fprintf(stderr, "  pow2        Calculate 2 raised to the power of n\n");
    fprintf(stderr, "  sqrt        Calculate the square root\n");
    fprintf(stderr, "  cbrt        Calculate the cubic root\n");
}

void display_binary(int num) {
    printf("Binary: ");
    for (int i = sizeof(num) * 8 - 1; i >= 0; i--) {
        printf("%d", (num >> i) & 1);
    }
    printf("\n");
}

void generate_mask(int index) {
    int mask = 1 << index;
    printf("Index %d:\n", index);
    printf("  Binary: ");
    display_binary(mask);
    printf("  Decimal: %d\n", mask);
    printf("  Hexadecimal: 0x%X\n\n", mask);
}

void generate_mask_range(int start, int end) {
    int mask = 0;
    int lower = start < end ? start : end;
    int upper = start > end ? start : end;

    for (int i = lower; i <= upper; i++) {
        mask |= 1 << i;
    }
    printf("Range %d..%d:\n", start, end);
    printf("  Binary: ");
    display_binary(mask);
    printf("  Decimal: %d\n", mask);
    printf("  Hexadecimal: 0x%X\n\n", mask);
}

void process_mask_arguments(char *argv[], int start, int argc) {
    for (int i = start; i < argc; i++) {
        if (strstr(argv[i], "..") != NULL) {
            int start_index, end_index;
            if (sscanf(argv[i], "%d..%d", &start_index, &end_index) == 2) {
                generate_mask_range(start_index, end_index);
            } else {
                fprintf(stderr, "Error: Invalid range format '%s'\n", argv[i]);
            }
        } else {
            int index = atoi(argv[i]);
            generate_mask(index);
        }
    }
}

void calculator(const char *operation, char *argv[], int start, int argc) {
    if (strcmp(operation, "mask") == 0) {
        printf("Operation: Generate Mask\n");
        process_mask_arguments(argv, start, argc);
    } else if (strcmp(operation, "and") == 0) {
        int num1 = atoi(argv[start]);
        int num2 = atoi(argv[start + 1]);
        int result = num1 & num2;
        printf("Operation: AND\n");
        printf("Result: Decimal: %d, Hex: %X, ", result, result);
        display_binary(result);
    } else if (strcmp(operation, "or") == 0) {
        int num1 = atoi(argv[start]);
        int num2 = atoi(argv[start + 1]);
        int result = num1 | num2;
        printf("Operation: OR\n");
        printf("Result: Decimal: %d, Hex: %X, ", result, result);
        display_binary(result);
    } else if (strcmp(operation, "xor") == 0) {
        int num1 = atoi(argv[start]);
        int num2 = atoi(argv[start + 1]);
        int result = num1 ^ num2;
        printf("Operation: XOR\n");
        printf("Result: Decimal: %d, Hex: %X, ", result, result);
        display_binary(result);
    } else if (strcmp(operation, "shl") == 0) {
        int num1 = atoi(argv[start]);
        int num2 = atoi(argv[start + 1]);
        int result = num1 << num2;
        printf("Operation: Shift Left by %d\n", num2);
        printf("Result: Decimal: %d, Hex: %X, ", result, result);
        display_binary(result);
    } else if (strcmp(operation, "shr") == 0) {
        int num1 = atoi(argv[start]);
        int num2 = atoi(argv[start + 1]);
        int result = num1 >> num2;
        printf("Operation: Shift Right by %d\n", num2);
        printf("Result: Decimal: %d, Hex: %X, ", result, result);
        display_binary(result);
    } else if (strcmp(operation, "log2") == 0) {
        int num = atoi(argv[start]);
        printf("Operation: Logarithm base 2\n");
        printf("Log2(%d) = %.4f\n", num, log2(num));
    } else if (strcmp(operation, "log10") == 0) {
        int num = atoi(argv[start]);
        printf("Operation: Logarithm base 10\n");
        printf("Log10(%d) = %.4f\n", num, log10(num));
    } else if (strcmp(operation, "pow2") == 0) {
        int num = atoi(argv[start]);
        printf("Operation: 2 raised to the power of %d\n", num);
        printf("2^%d = %.0f\n", num, pow(2, num));
    } else if (strcmp(operation, "sqrt") == 0) {
        int num = atoi(argv[start]);
        printf("Operation: Square root\n");
        printf("sqrt(%d) = %.4f\n", num, sqrt(num));
    } else if (strcmp(operation, "cbrt") == 0) {
        int num = atoi(argv[start]);
        printf("Operation: Cubic root\n");
        printf("cbrt(%d) = %.4f\n", num, cbrt(num));
    } else if (strcmp(operation, "bin") == 0) {
        int num = atoi(argv[start]);
        printf("Operation: Convert to Binary\n");
        display_binary(num);
    } else if (strcmp(operation, "hex") == 0) {
        int num = atoi(argv[start]);
        printf("Operation: Convert to Hexadecimal\n");
        printf("Hexadecimal: %X\n", num);
    } else if (strcmp(operation, "dec") == 0) {
        int num = atoi(argv[start]);
        printf("Operation: Convert to Decimal\n");
        printf("Decimal: %d\n", num);
    } else {
        fprintf(stderr, "Unknown operation: %s\n", operation);
        print_usage("prog_name");
    }
}

void display_file_size(const char *filename) {
    struct stat file_stat;
    if (stat(filename, &file_stat) == -1) {
        perror("Error getting file size");
        return;
    }
    printf("File size: %lld bytes\n", (long long)file_stat.st_size);
}

void display_file_type(const char *filename) {
    struct stat file_stat;
    if (stat(filename, &file_stat) == -1) {
        perror("Error getting file type");
        return;
    }
    printf("File type: ");
    if (S_ISREG(file_stat.st_mode)) {
        printf("Regular file\n");
    } else if (S_ISDIR(file_stat.st_mode)) {
        printf("Directory\n");
    } else {
        printf("Other\n");
    }
}

int main(int argc, char *argv[]) {
    int opt;
    int show_size = 0, show_type = 0, calculator_mode = 0;

    while ((opt = getopt(argc, argv, "stc")) != -1) {
        switch (opt) {
            case 's':
                show_size = 1;
                break;
            case 't':
                show_type = 1;
                break;
            case 'c':
                calculator_mode = 1;
                break;
            default:
                print_usage(argv[0]);
                return EXIT_FAILURE;
        }
    }

    if (calculator_mode) {
        if (optind >= argc) {
            fprintf(stderr, "Error: Insufficient arguments for calculator\n");
            print_usage(argv[0]);
            return EXIT_FAILURE;
        }
        const char *operation = argv[optind];
        calculator(operation, argv, optind + 1, argc);
    } else {
        if (optind >= argc) {
            fprintf(stderr, "Error: No filename provided\n");
            print_usage(argv[0]);
            return EXIT_FAILURE;
        }
        const char *filename = argv[optind];
        if (show_size) {
            display_file_size(filename);
        }
        if (show_type) {
            display_file_type(filename);
        }
    }

    return EXIT_SUCCESS;
}
