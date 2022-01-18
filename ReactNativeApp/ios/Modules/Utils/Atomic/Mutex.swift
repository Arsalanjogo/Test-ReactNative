//
//  Mutex.swift
//  jogo
//
//  Created by arham on 05/08/2021.
//

import Foundation


class Mutex {
private var mutex = pthread_mutex_t()

init() { pthread_mutex_init(&mutex, nil) }

func lock() { pthread_mutex_lock(&mutex) }

func unlock() { pthread_mutex_unlock(&mutex) }

}
