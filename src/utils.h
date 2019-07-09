//
// Created by peter on 07/07/19.
//

#ifndef CBMS_UTILS_H
#define CBMS_UTILS_H

#include <vector>
#include <iostream>
#include <random>

#define EXIT(text) std::cout << text << std::endl; exit(-1);

#define SWAP_INT(x,y) { x = x + y; y = x - y; x = x - y; }

bool is_power_of_two(int x) {
    return x && !(x & (x - 1));
}

std::vector<int> generate(const int size, const int key_from, const int key_to) {
    std::vector<int> v;

    std::random_device rd;
    std::mt19937 rng(rd());
    std::uniform_int_distribution<int> uni(key_from, key_to);

    for (int i = 0; i < size; ++i) {
        v.push_back(uni(rng));
    }

    return v;
}

template <class T>
bool compare(std::vector<T> first, T *second) {
    for (int i = 0; i < first.size(); ++i) {
        if (first[i] != second[i]) {
            return false;
        }
    }

    return true;
}

template <class T>
void print(std::vector<T> v) {
    for (const auto &x : v) {
        std::cout << x << " ";
    }

    std::cout << std::endl;
}

template <class T>
void print(T *v, int size) {
    for (int i = 0; i < size; ++i) {
        std::cout << v[i] << " ";
    }

    std::cout << std::endl;
}

#endif //CBMS_UTILS_H
