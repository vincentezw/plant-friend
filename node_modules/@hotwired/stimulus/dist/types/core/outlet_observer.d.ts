import { Multimap } from "../multimap";
import { SelectorObserverDelegate } from "../mutation-observers";
import { Context } from "./context";
import { Controller } from "./controller";
declare type SelectorObserverDetails = {
    outletName: string;
};
export interface OutletObserverDelegate {
    outletConnected(outlet: Controller, element: Element, outletName: string): void;
    outletDisconnected(outlet: Controller, element: Element, outletName: string): void;
}
export declare class OutletObserver implements SelectorObserverDelegate {
    readonly context: Context;
    readonly delegate: OutletObserverDelegate;
    readonly outletsByName: Multimap<string, Controller>;
    readonly outletElementsByName: Multimap<string, Element>;
    private selectorObserverMap;
    constructor(context: Context, delegate: OutletObserverDelegate);
    start(): void;
    stop(): void;
    refresh(): void;
    selectorMatched(element: Element, _selector: string, { outletName }: SelectorObserverDetails): void;
    selectorUnmatched(element: Element, _selector: string, { outletName }: SelectorObserverDetails): void;
    selectorMatchElement(element: Element, { outletName }: SelectorObserverDetails): boolean;
    connectOutlet(outlet: Controller, element: Element, outletName: string): void;
    disconnectOutlet(outlet: Controller, element: Element, outletName: string): void;
    disconnectAllOutlets(): void;
    private selector;
    private get outletDependencies();
    private get outletDefinitions();
    private get dependentControllerIdentifiers();
    private get dependentContexts();
    private hasOutlet;
    private getOutlet;
    private getOutletFromMap;
    private get scope();
    private get identifier();
    private get application();
    private get router();
}
export {};
