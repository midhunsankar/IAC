import * as React from 'react';
import { useState, useEffect } from 'react'
import Col from 'react-bootstrap/Col';
import { useParams } from "react-router";
import { Item } from '../model/item';
import Image from 'react-bootstrap/Image';

function Details() {

    const [itemDetail, setItem] = useState<Item>({} as Item)
    const  param  = useParams();

    useEffect(() => {
        fetchItem()
    }, [])

    const fetchItem = async () => {
        try {

        const response = await fetch('/api/item/' + param.category + '/' + param.id)
        const data = await response.json()
            if (!response.ok) {
                throw new Error('Network response was not ok')
            }
            console.log(data)
        setItem(data.item)
        } catch (error) {
        console.error('Error fetching items:', error)
        }
    }
  
  return (
    <>
        <Col md={12} className='bg-light'>
            <hr></hr>
            { itemDetail.images && itemDetail.images.map((image, index) => (
                <Image key={index} src={"/images/" + image} alt={`Item image ${index + 1}`} fluid   />
            ))}
            <h1>{itemDetail.name}</h1>
            <p>{itemDetail.description}</p>
            <p>Price: {itemDetail.price}</p>
            <p>Brand: {itemDetail.brand}</p>
            <p>Category: {itemDetail.category}</p>
            <p>Subcategory: {itemDetail.subcategory}</p>
            <p>Gender: {itemDetail.gender}</p>
        </Col>
    </>
  )
}

export { Details }

