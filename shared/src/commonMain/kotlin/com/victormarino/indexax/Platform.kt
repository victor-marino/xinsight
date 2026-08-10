package com.victormarino.indexax

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform
