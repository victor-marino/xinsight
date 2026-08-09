package com.victormarino.xinsight

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform