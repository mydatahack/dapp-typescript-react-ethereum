/* eslint-disable */
import { useEffect, useState } from 'react'
import Web3 from 'web3'
// import * as GamingAbi from '../../../build/contracts/Gaming.json'
import { gamingAbi as GamingAbi } from '../../abi/gamingAbi'

const web3 = new Web3(Web3.givenProvider)
//contract address must match the address provided by Truffle after migrations
const contractAddr = '0x17aF8fe01CE70706a1717a7B4231c406bBA6ad21'
const GamingContract = new web3.eth.Contract(GamingAbi as any, contractAddr)

export const Connect: React.VFC = () => {
  const [account, setAccount] = useState()
  const [provider, setProvider] = useState()
  useEffect(() => {
    const getAccount = async () => {
      await (window as any).ethereum.enable()
    }
    const account = (getAccount() as any)[0]
    console.log('getting account: Account')
  }, [])

  return (
    <>
      <h1>This is Connect component</h1>
    </>
  )
}
