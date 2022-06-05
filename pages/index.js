// import React, { Component } from 'react';
import Head from "next/head";
import Link from "next/link";
import styles from "../styles/Home.module.css";
import * as React from "react";
import NameCard from "../components/card/index";
import Header from "../components/header/index";

export default function Home() {
  return (
    <>
      <Head>
        <title>Milk Supply</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <Header title="Home" />
      <div className={styles.homeCardContainer}>
        <div className={styles.homeContentCards}>
          <Link href="/admin">
            <a>
              <NameCard title="Admin" />
            </a>
          </Link>
          <Link href="/status">
            <a>
              <NameCard title="Public" />
            </a>
          </Link>
        </div>
      </div>
    </>
  );
}
