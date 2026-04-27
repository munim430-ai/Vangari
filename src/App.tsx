import { ArrowRight, Banknote, Bell, Camera, Gift, MapPin, Recycle, ShieldCheck, Sparkles, Truck, Wallet } from 'lucide-react';
import { motion } from 'motion/react';
import type { ReactNode } from 'react';
import './index.css';

const categories = ['Paper', 'Plastic', 'Iron', 'E-waste'];
const steps = [
  ['Upload scrap photo', 'User uploads a photo from home.', <Camera />],
  ['AI estimates price', 'App gives an estimated value in BDT.', <Sparkles />],
  ['Confirm pickup', 'Collector arrives at the saved address.', <Truck />],
  ['Earn payout', 'User receives wallet balance and reward options.', <Wallet />],
];

export default function App() {
  return (
    <main className="min-h-screen overflow-hidden bg-[#f6f8fb] text-[#111827]">
      <nav className="fixed inset-x-0 top-0 z-50 border-b border-white/60 bg-white/80 backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-5 py-4">
          <div className="flex items-center gap-3 text-xl font-black tracking-tight">
            <span className="grid h-11 w-11 place-items-center rounded-2xl bg-[#06b34f] text-white shadow-lg shadow-green-200"><Recycle /></span>
            <span>Vangari <span className="text-[#06b34f]">ভাঙারি</span></span>
          </div>
          <a href="#launch" className="rounded-full bg-[#111827] px-5 py-3 text-sm font-bold text-white shadow-xl shadow-gray-300">Join early access</a>
        </div>
      </nav>

      <section className="relative mx-auto grid max-w-7xl gap-12 px-5 pb-20 pt-32 lg:grid-cols-[1.05fr_.95fr] lg:items-center">
        <div className="absolute right-0 top-24 h-96 w-96 rounded-full bg-[#06b34f]/20 blur-3xl" />
        <motion.div initial={{opacity:0,y:24}} animate={{opacity:1,y:0}} transition={{duration:.7}} className="relative">
          <p className="mb-5 inline-flex rounded-full border border-green-100 bg-white px-4 py-2 text-sm font-bold text-[#06b34f] shadow-sm">Bangladesh smart scrap pickup app</p>
          <h1 className="max-w-4xl text-5xl font-black leading-[.98] tracking-tight md:text-7xl">Turn household scrap into instant cash, without bargaining.</h1>
          <p className="mt-7 max-w-2xl text-lg leading-8 text-[#6b7280]">Vangari connects homes with verified collectors, AI-assisted price estimation, scheduled pickup, eco rewards, and payout through bKash or Nagad.</p>
          <div className="mt-9 flex flex-col gap-4 sm:flex-row">
            <a href="#launch" className="inline-flex items-center justify-center gap-2 rounded-2xl bg-[#06b34f] px-7 py-4 font-black text-white shadow-2xl shadow-green-200">Book a demo <ArrowRight size={19}/></a>
            <a href="#how" className="inline-flex items-center justify-center rounded-2xl border border-gray-200 bg-white px-7 py-4 font-black text-[#111827]">How it works</a>
          </div>
          <div className="mt-10 grid max-w-2xl grid-cols-3 gap-4 text-center">
            {[['0 BDT','signup fee'],['4','scrap categories'],['AI','price check']].map(([a,b])=><div className="rounded-3xl bg-white p-5 shadow-sm ring-1 ring-gray-100" key={b}><div className="text-3xl font-black">{a}</div><div className="text-xs font-bold uppercase tracking-wider text-gray-400">{b}</div></div>)}
          </div>
        </motion.div>

        <motion.div initial={{opacity:0,scale:.94}} animate={{opacity:1,scale:1}} transition={{duration:.7,delay:.15}} className="relative mx-auto w-full max-w-[410px]">
          <div className="absolute -inset-8 rounded-[3rem] bg-[#06b34f]/20 blur-3xl" />
          <div className="relative rounded-[2.6rem] border border-white bg-white p-4 shadow-2xl shadow-gray-300">
            <div className="rounded-[2rem] bg-[#f6f8fb] p-6">
              <div className="flex items-start justify-between"><div><p className="text-gray-500">Welcome back,</p><p className="text-4xl">Hi</p></div><Bell className="text-gray-400"/></div>
              <div className="mt-8 rounded-[2rem] bg-[#06b34f] p-7 text-white shadow-2xl shadow-green-200"><p className="font-bold text-green-100">Eco Balance</p><p className="mt-2 text-5xl font-black">BDT 0</p><p className="mt-6 inline-flex rounded-full bg-white/15 px-4 py-2 text-sm font-bold">Top 5% in Dhaka</p></div>
              <div className="mt-5 grid grid-cols-2 gap-4"><Mini icon={<Truck/>} title="Pickups" value="0"/><Mini icon={<Recycle/>} title="Recycled" value="12 kg"/></div>
              <div className="mt-5 rounded-3xl border border-yellow-100 bg-yellow-50 p-4"><div className="flex items-center gap-4"><div className="grid h-14 w-14 place-items-center rounded-2xl bg-yellow-100 text-yellow-600"><Gift/></div><div><b>Invite and Earn 50 BDT</b><p className="text-sm text-gray-500">Send invite to your neighbor.</p></div></div></div>
              <h3 className="mt-7 text-2xl font-black">Scrap Categories</h3>
              <div className="mt-4 grid grid-cols-4 gap-3">{categories.map((c,i)=><div className="text-center text-xs font-bold text-gray-600" key={c}><div className="mb-2 rounded-2xl bg-white p-4 text-xl shadow-sm">{['📄','🥤','🧱','💻'][i]}</div>{c}</div>)}</div>
            </div>
          </div>
        </motion.div>
      </section>

      <section id="how" className="bg-white py-20"><div className="mx-auto max-w-7xl px-5"><h2 className="text-4xl font-black tracking-tight md:text-5xl">Designed for the real Bangladeshi scrap market.</h2><div className="mt-10 grid gap-5 md:grid-cols-4">{steps.map(([title,text,icon])=><Card key={String(title)} icon={icon as ReactNode} title={String(title)} text={String(text)}/>)}</div></div></section>

      <section className="mx-auto grid max-w-7xl gap-8 px-5 py-20 lg:grid-cols-3">
        <Feature icon={<ShieldCheck/>} title="Verified collectors" text="Cleaner, safer pickup experience for apartments, families, and local communities." />
        <Feature icon={<Banknote/>} title="bKash and Nagad payout" text="Reward options built for Bangladesh, including charity donation mode." />
        <Feature icon={<MapPin/>} title="Local pickup network" text="Start city-by-city, then scale through referral loops and collector partnerships." />
      </section>

      <section id="launch" className="mx-auto max-w-5xl px-5 pb-24"><div className="rounded-[2.5rem] bg-[#111827] p-8 text-white shadow-2xl md:p-14"><p className="mb-4 font-bold text-[#06b34f]">Early access</p><h2 className="text-4xl font-black md:text-6xl">Launch Vangari in your area.</h2><p className="mt-5 max-w-2xl text-lg leading-8 text-gray-300">Built for homes, apartment buildings, universities, offices, and local scrap collectors. First launch target: dense urban neighborhoods in Bangladesh.</p><div className="mt-8 flex flex-col gap-4 sm:flex-row"><a className="rounded-2xl bg-[#06b34f] px-7 py-4 text-center font-black text-white" href="mailto:keystoneeducationconsultancy@gmail.com">Contact founder</a><a className="rounded-2xl bg-white/10 px-7 py-4 text-center font-black text-white" href="https://github.com/munim430-ai/Vangari">View GitHub</a></div></div></section>
    </main>
  );
}

function Mini({icon,title,value}:{icon:ReactNode;title:string;value:string}){return <div className="rounded-3xl bg-white p-4 shadow-sm"><div className="mb-3 text-[#06b34f]">{icon}</div><p className="text-xs font-black uppercase tracking-wider text-gray-400">{title}</p><p className="text-2xl font-black">{value}</p></div>}
function Card({icon,title,text}:{icon:ReactNode;title:string;text:string}){return <div className="rounded-3xl bg-[#f6f8fb] p-6 ring-1 ring-gray-100"><div className="mb-5 grid h-14 w-14 place-items-center rounded-2xl bg-white text-[#06b34f] shadow-sm">{icon}</div><h3 className="text-xl font-black">{title}</h3><p className="mt-3 leading-7 text-gray-500">{text}</p></div>}
function Feature({icon,title,text}:{icon:ReactNode;title:string;text:string}){return <div className="rounded-[2rem] bg-white p-8 shadow-sm ring-1 ring-gray-100"><div className="mb-6 text-[#06b34f]">{icon}</div><h3 className="text-2xl font-black">{title}</h3><p className="mt-3 leading-7 text-gray-500">{text}</p></div>}
