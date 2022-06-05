import Head from "next/head";
import Link from "next/link";
import styles from "../../styles/Home.module.css";
import React, { useEffect, useState } from "react";
import Header from "../../components/header/index";
import HomeButton from "../../components/homeButton";
import EventCard from "../../components/eventCards";

let arr = [1, 2, 3, 4, 5, 6];

export default function Status() {
  const [productId, setproductId] = useState("");

  const getInput = (id) => {
    setproductId(id);
  };
  return (
    <>
      <Head>
        <title>Milk Supply</title>
        <meta name="description" content="Generated by create next app" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <div className={styles.navBar}>
        <Header title="Status" />
        <Link href="/">
          <a>
            <HomeButton />
          </a>
        </Link>
      </div>
      <div className={styles.descriptionFormCard}>
        <form name="search">
          <label className={styles.descriptionFormTitle}>Product Id: </label>
          <input
            className={styles.descriptionFormInput}
            name="id"
            type="text"
            // onChange={(e) => {
            //   e.preventDefault();
            //   console.log(e.target.value);
            //   setproductId(e.target.value);
            // }}
          ></input>
          <input
            className={styles.formButton}
            value="Fetch"
            type="submit"
            onClick={(e) => {
              e.preventDefault();
              getInput(search.id);
            }}
          ></input>
        </form>
      </div>
      <div className={styles.descriptionCard}>
        <div className={styles.descriptionFormTitle}>Product description: </div>
        <div className={styles.descriptionFormTitle}> desc</div>
      </div>
      <div className={styles.eventRowCard}>
        {arr &&
          arr.map((row) => (
            <EventCard location="Chennai" temperature="36 C" time="10:00 pm" />
          ))}
      </div>
    </>
  );
}